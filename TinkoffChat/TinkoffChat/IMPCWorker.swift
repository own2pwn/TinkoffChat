//
//  IMPCWorker.swift
//  TinkoffChat
//
//  Created by Evgeniy on 22.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit
import MultipeerConnectivity

struct Peer
{
    let userID: String
    let userName: String?
}

protocol IMPCWorker: class
{
    func send(message: String, to: String, completion: (Error?) -> Void)
    func peers(where state: UserState)
    
    var online: Bool { get set }
    
    weak var delegate: IMPCWorkerDelegate? { get set }
}

protocol IMPCWorkerDelegate: class
{
    // MARK: Discovering
    
    func didFoundUser(userID: String, userName: String?)
    
    func didLostUser(userID: String)
    
    // MARK: Messages
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
    
    // MARK: Errors
    
    func failedToStartBrowsingForUsers(error: Error)
    
    func failedToStartAdvertising(error: Error)
}

final class MPCWorker: NSObject, IMPCWorker, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate, MCSessionDelegate
{
    // MARK: - IMPCWorker
    
    func send(message: String, to: String, completion: (Error?) -> Void)
    {
        
    }
    
    func peers(where state: UserState)
    {
        
    }
    
    var online: Bool
    {
        didSet
        {
            setBrowsingEnabled(online)
        }
    }
    
    var delegate: IMPCWorkerDelegate?
    
    // MARK: - Life cycle
    
    override init()
    {
        browser = MCNearbyServiceBrowser(peer: localPeer, serviceType: serviceType)
        browser.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer: localPeer, discoveryInfo: discoveryInfo, serviceType: serviceType)
        advertiser.delegate = self
        
        setBrowsingEnabled(true)
    }
    
    // MARK: - MCNearbyServiceAdvertiserDelegate
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void)
    {
        guard let context = context, let inviteData = try? JSONSerialization.jsonObject(with: context, options: .allowFragments) as? [String: String?], let userName = inviteData?[KDiscoveryInfo.UserName] else { return }
        
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
            lastState[peerID] = state
            break
        case .connected:
            lastState[peerID] = state
            break
        default:
            if lastState[peerID] == .connected
            {
                lastState[peerID] = state
                delegate?.didLostUser(userID: peerID.displayName)
                removeSession(for: peerID)
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
    
    // MARK: - Private properties
    
    // MARK: Lazy
    
    private lazy var localPeer: MCPeerID = {
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
    }()
    
    // MARK: Stored
    
    private let serviceType = "tinkoff-chat"
    
    private let discoveryInfo = [KDiscoveryInfo.UserName: UIDevice.current.name]
    
    private var browser: MCNearbyServiceBrowser
    
    private var advertiser: MCNearbyServiceAdvertiser
    
    private var sessions = [MCPeerID: MCSession]()
    
    private let connectionTimeout = 3.0
    
    private var lastState = [MCPeerID: MCSessionState]()
    
    private var foundPeers = [Peer]()
    
    // MARK: Session
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {}
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) { certificateHandler(true) }
}
