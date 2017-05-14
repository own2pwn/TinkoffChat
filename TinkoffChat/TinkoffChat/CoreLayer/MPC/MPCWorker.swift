//
//  MPCWorker.swift
//  TinkoffChat
//
//  Created by Evgeniy on 22.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import MultipeerConnectivity
import CoreData

enum MultipeerCommunicatorError: Error
{
    case noSessionData
    case noPeersInSession
}

final class MPCWorker: NSObject, IMPCWorker,
    MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate, MCSessionDelegate
{
    // MARK: - IMPCWorker
    
    func send(message: String,
              to userId: String,
              completion: (Error?) -> Void)
    {
        guard let session = getSession(for: userId) else
        {
            completion(MultipeerCommunicatorError.noSessionData)
            return
        }
        guard session.connectedPeers.count > 0 else
        {
            if let lostPeer = getPeer(by: userId)
            {
                sessions.removeValue(forKey: lostPeer)
            }
            mpcCoreDataHelper.didLostUser(userId)
            completion(MultipeerCommunicatorError.noPeersInSession)
            return
        }
        let msg = ["eventType": "TextMessage",
                   "messageId": CommunicationHelper.generateUniqueId(),
                   "text": message]
        do
        {
            let msgData = try JSONSerialization.data(withJSONObject: msg, options: .prettyPrinted)
            try session.send(msgData, toPeers: session.connectedPeers, with: .reliable)
            completion(nil)
        }
        catch
        {
            completion(error)
        }
    }
    
    var online: Bool
    {
        get { return _online }
        set
        {
            _online = newValue
            setBrowsingEnabled(newValue)
        }
    }
    
    // MARK: - MCNearbyServiceAdvertiserDelegate
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void)
    {
        // swiftlint:disable line_length
        guard let context = context,
            let inviteData = try? JSONSerialization.jsonObject(with: context, options: .allowFragments) as? [String: String?],
            let userName = inviteData?[KDiscoveryInfo.UserName] else { return }
        
        let session = getSessionOrCreate(for: peerID)
        
        for peer in session.connectedPeers where peer.displayName == peerID.displayName
        {
            invitationHandler(false, nil)
            return
        }
        invitationHandler(true, session)
        mpcCoreDataHelper.didFoundUser(peerID.displayName, name: userName)
        // swiftlint:enable line_length
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error)
    {
        print("^ [ERROR]: MPCWorker advertiser didNotStartAdvertisingPeer with error: \(error.localizedDescription)")
    }
    
    // MARK: - Browsing
    
    func browser(_ browser: MCNearbyServiceBrowser,
                 foundPeer peerID: MCPeerID,
                 withDiscoveryInfo info: [String: String]?)
    {
        guard let info = info else { return }
        
        let session = getSessionOrCreate(for: peerID)
        if !session.connectedPeers.contains(peerID)
        {
            let ctx = try? JSONSerialization.data(withJSONObject: discoveryInfo, options: .prettyPrinted)
            browser.invitePeer(peerID, to: session, withContext: ctx, timeout: connectionTimeout)
        }
        mpcCoreDataHelper.didFoundUser(peerID.displayName, name: info["userName"])
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID)
    {
        removeSession(for: peerID)
        mpcCoreDataHelper.didLostUser(peerID.displayName)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error)
    {
        print("^ [ERROR]: MPCWorker advertiser didNotStartBrowsingForPeers with error: \(error.localizedDescription)")
    }
    
    // MARK: - Session
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState)
    {
        switch state
        {
        case .connecting:
            lastState[peerID] = state
            break
        case .connected:
            lastState[peerID] = state
            break
        default:
            if lastState[peerID] == .connected
            {
                lastState[peerID] = state
                mpcCoreDataHelper.didLostUser(peerID.displayName)
                removeSession(for: peerID)
            }
            break
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID)
    {
        guard let data = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            as? [String: String] else { return }
        
        if data?["eventType"] == "TextMessage", let msg = data?["text"]
        {
            mpcCoreDataHelper.didReceiveMessage(msg, from: peerID.displayName)
        }
    }
    
    // MARK: - Life cycle
    
    override init()
    {
        super.init()
        
        displayName = mpcCoreDataHelper.updateOrCreateAppUser(localPeer.displayName)
        
        advertiser.delegate = self
        browser.delegate = self
        
        online = true
    }
    
    // MARK: - Private methods
    
    private func setBrowsingEnabled(_ enabled: Bool)
    {
        if enabled
        {
            advertiser.startAdvertisingPeer()
            browser.startBrowsingForPeers()
        }
        else
        {
            advertiser.stopAdvertisingPeer()
            browser.stopBrowsingForPeers()
        }
    }
    
    private func getSessionOrCreate(for peerID: MCPeerID) -> MCSession
    {
        if let session = sessions[peerID]
        {
            return session
        }
        let newSession = MCSession(peer: localPeer, securityIdentity: nil, encryptionPreference: .none)
        newSession.delegate = self
        sessions[peerID] = newSession
        
        return newSession
    }
    
    private func removeSession(for peerID: MCPeerID)
    {
        sessions.removeValue(forKey: peerID)
    }
    
    private func getSession(for userID: String) -> MCSession?
    {
        for session in sessions where session.key.displayName == userID { return session.value }
        
        return nil
    }
    
    private func getPeer(by userID: String) -> MCPeerID?
    {
        for session in sessions where session.key.displayName == userID { return session.key }
        
        return nil
    }
    
    // MARK: - Private properties
    
    // MARK: Lazy
    
    private lazy var localPeer: MCPeerID = {
        let defaults = UserDefaults.standard
        var ret: MCPeerID!
        
        if let peerIDData = UserDefaults.standard.value(forKey: KUserDefaults.DeviceMCPeerID) as? Data
        {
            // swiftlint:disable:next force_cast
            ret = NSKeyedUnarchiver.unarchiveObject(with: peerIDData) as! MCPeerID
        }
        else
        {
            ret = MCPeerID(displayName: UIDevice.current.identifierForVendor!.uuidString)
            let peerIDData = NSKeyedArchiver.archivedData(withRootObject: ret)
            defaults.set(peerIDData, forKey: KUserDefaults.DeviceMCPeerID)
            defaults.synchronize()
        }
        return ret
    }()
    
    private lazy var browser: MCNearbyServiceBrowser = {
        MCNearbyServiceBrowser(peer: self.localPeer, serviceType: self.serviceType)
    }()
    
    private lazy var advertiser: MCNearbyServiceAdvertiser = {
        MCNearbyServiceAdvertiser(peer: self.localPeer,
                                  discoveryInfo: self.discoveryInfo,
                                  serviceType: self.serviceType)
    }()
    
    private lazy var discoveryInfo: [String: String] = {
        [KDiscoveryInfo.UserName: self.displayName]
    }()
    
    // MARK: Stored
    
    private let serviceType = "tinkoff-chat"
    
    private let connectionTimeout = 3.0
    
    private var _online = false
    
    private var displayName: String = UIDevice.current.name
    
    private var sessions = [MCPeerID: MCSession]()
    
    private var lastState = [MCPeerID: MCSessionState]()
    
    private var currentAppUser: AppUser!
    
    private var currentUser: User!
    
    // MARK: Core objects
    
    private let mpcCoreDataHelper: IMPCCoreDataHelper = MPCCoreDataHelper()
    
    // MARK: -
    
    // swiftlint:disable line_length
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {}
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) { certificateHandler(true) }
}
