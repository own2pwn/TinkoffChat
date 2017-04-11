//
//  MultipeerCommunicator.swift
//  TinkoffChat
//
//  Created by Evgeniy on 11.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MultipeerCommunicator: NSObject, Communicator, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate, MCSessionDelegate
{
    // MARK: - Public properties
    
    // MARK: Communicator
    
    var online: Bool
    {
        get
        {
            return _online
        }
        set
        {
            _online = newValue
            setBrowsingEnabled(newValue)
        }
    }
    
    weak var delegate: CommunicatorDelegate?
    
    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> Void)?)
    {
        guard let session = getSession(for: userID) else
        {
            completionHandler?(false, MultipeerCommunicatorError.noSessionData)
            return
        }
        
        guard session.connectedPeers.count > 0 else
        {
            if let lostPeer = getPeer(by: userID)
            {
                sessions.removeValue(forKey: lostPeer)
            }
            delegate?.didLostUser(userID: userID)
            completionHandler?(false, MultipeerCommunicatorError.noPeersInSession)
            return
        }
        
        let msg = ["eventType": "TextMessage", "messageId": generateMessageId(), "text": string]
        do
        {
            let msgData = try JSONSerialization.data(withJSONObject: msg, options: .prettyPrinted)
            try session.send(msgData, toPeers: session.connectedPeers, with: .reliable)
            completionHandler?(true, nil)
        }
        catch
        {
            completionHandler?(false, error)
        }
    }
    
    // MARK: - Life cycle
    
    override init()
    {
        super.init()
        
        localPeer = loadOrCreateDevicePeer()
        
        browser = MCNearbyServiceBrowser(peer: localPeer, serviceType: serviceType)
        browser.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer: localPeer, discoveryInfo: discoveryInfo, serviceType: serviceType)
        advertiser.delegate = self
        
        online = true
    }
    
    deinit
    {
        online = false
    }
    
    // MARK: - Advertising
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void)
    {
        guard let context = context, let inviteData = try? JSONSerialization.jsonObject(with: context, options: .allowFragments) as? [String: String?], let userName = inviteData?[KDiscoveryInfo.UserName] else { return }
        
        print("`[Invite from peer: \(peerID) with ctx: \(inviteData)")
        let session = getSessionOrCreate(for: peerID)
        
        for peer in session.connectedPeers
        {
            if peer.displayName == peerID.displayName
            {
                invitationHandler(false, nil)
                return
            }
        }
        invitationHandler(true, session)
        delegate?.didFoundUser(userID: peerID.displayName, userName: userName)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error)
    {
        delegate?.failedToStartAdvertising(error: error)
    }
    
    // MARK: - Browsing
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?)
    {
        guard let info = info else { return }
        print("`[Found peer: \(peerID) with info \(info)")
        
        let session = getSessionOrCreate(for: peerID)
        if !session.connectedPeers.contains(peerID)
        {
            let ctx = try! JSONSerialization.data(withJSONObject: discoveryInfo, options: .prettyPrinted)
            browser.invitePeer(peerID, to: session, withContext: ctx, timeout: connectionTimeout)
        }
        delegate?.didFoundUser(userID: peerID.displayName, userName: info["userName"])
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID)
    {
        print("`[Lost peer: \(peerID)")
        removeSession(for: peerID)
        delegate?.didLostUser(userID: peerID.displayName)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error)
    {
        delegate?.failedToStartBrowsingForUsers(error: error)
    }
    
    // MARK: - Session
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState)
    {
        switch state
        {
        case .connecting:
            print("`[\(peerID.displayName) is connecting to \(session) with peers: \(session.connectedPeers)")
            lastState[peerID] = state
            break
        case .connected:
            print("`[\(peerID.displayName) is connected to \(session) with peers: \(session.connectedPeers)")
            lastState[peerID] = state
            break
        default:
            if lastState[peerID] == .connected
            {
                lastState[peerID] = state
                delegate?.didLostUser(userID: peerID.displayName)
            }
            break
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID)
    {
        guard let data = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: String] else { return }
        
        if data?["eventType"] == "TextMessage", let msg = data?["text"]
        {
            delegate?.didReceiveMessage(text: msg, fromUser: peerID.displayName, toUser: localPeer.displayName)
        }
    }
    
    // MARK: - Private properties
    
    private var localPeer: MCPeerID!
    
    private let serviceType = "tinkoff-chat"
    
    private let discoveryInfo = [KDiscoveryInfo.UserName: UIDevice.current.name]
    
    private var browser: MCNearbyServiceBrowser!
    
    private var advertiser: MCNearbyServiceAdvertiser!
    
    private var _online = false
    
    private var sessions = [MCPeerID: MCSession]()
    
    private let connectionTimeout = 3.0
    
    private var lastState = [MCPeerID: MCSessionState]()
    
    // MARK: - Private methods
    
    private func loadOrCreateDevicePeer() -> MCPeerID
    {
        let defaults = UserDefaults.standard
        var ret: MCPeerID!
        
        if let peerIDData = UserDefaults.standard.value(forKey: KUserDefaults.DeviceMCPeerID) as? Data
        {
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
    }
    
    func getSessionOrCreate(for peerID: MCPeerID) -> MCSession
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
    
    func getSession(for userID: String) -> MCSession?
    {
        for session in sessions where session.key.displayName == userID { return session.value }
        
        return nil
    }
    
    func removeSession(for peerID: MCPeerID)
    {
        sessions.removeValue(forKey: peerID)
    }
    
    func getPeer(by userID: String) -> MCPeerID?
    {
        for session in sessions where session.key.displayName == userID { return session.key }
        
        return nil
    }
    
    // MARK: - Helping functions
    
    // MARK: Communication
    
    func setBrowsingEnabled(_ enabled: Bool)
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
    
    func generateMessageId() -> String
    {
        let string = "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string!
    }
    
    // MARK: Session
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID)
    {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress)
    {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?)
    {
    }
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void)
    {
        certificateHandler(true)
    }
}
