//
//  OperationDataStoreService.swift
//  TinkoffChat
//
//  Created by Evgeniy on 23.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

final class OperationDataStoreService: IDataStore
{
    // MARK: - IDataStore
    
    func saveProfileData(_ profile: Profile, completion: @escaping (Bool, Error?) -> Void)
    {
        let op = SaveProfileDataOperation(dataStore: dataStore, profile, completion: { bSuccess, err in
            OperationQueue.main.addOperation
            {
                completion(bSuccess, err)
            }
        })
        
        queue.addOperation(op)
    }
    
    func loadProfileData(completion: @escaping (Profile, Error?) -> Void)
    {
        let op = LoadProfileDataOperation(dataStore: dataStore, completion: { profile, err in
            OperationQueue.main.addOperation
            {
                completion(profile, err)
            }
        })
        queue.addOperation(op)
    }
    
    // MARK: - Life cycle
    
    init(dataStore: IDataStore)
    {
        self.dataStore = dataStore
        queue.qualityOfService = .userInitiated
    }
    
    // MARK: - Private properties
    
    private let dataStore: IDataStore
    
    private let queue = OperationQueue()
}

private class AsyncOperation: Operation
{
    enum State: String
    {
        case Ready, Executing, Finished
        var keyPath: String
        {
            return "is" + self.rawValue
        }
    }
    
    var state = State.Ready
    {
        willSet(newValue)
        {
            self.willChangeValue(forKey: newValue.keyPath)
            self.willChangeValue(forKey: self.state.keyPath)
        }
        
        didSet
        {
            self.didChangeValue(forKey: oldValue.keyPath)
            self.didChangeValue(forKey: self.state.keyPath)
        }
    }
    
    override var isAsynchronous: Bool { return true }
    
    override var isExecuting: Bool { return state == .Executing }
    
    override var isFinished: Bool { return state == .Finished }
}

private class SaveProfileDataOperation: AsyncOperation
{
    let profile: Profile
    let completion: (Bool, Error?) -> Void
    
    init(dataStore: IDataStore, _ profile: Profile, completion: @escaping (Bool, Error?) -> Void)
    {
        self.dataStore = dataStore
        self.profile = profile
        self.completion = completion
    }
    
    override func start()
    {
        if isCancelled
        {
            state = .Finished
            return
        }
        state = .Executing
        dataStore.saveProfileData(profile, completion: completion)
        state = .Finished
    }
    
    private let dataStore: IDataStore
}

private class LoadProfileDataOperation: AsyncOperation
{
    let completion: (Profile, Error?) -> Void
    
    init(dataStore: IDataStore, completion: @escaping (Profile, Error?) -> Void)
    {
        self.dataStore = dataStore
        self.completion = completion
    }
    
    override func start()
    {
        if isCancelled
        {
            state = .Finished
            return
        }
        state = .Executing
        dataStore.loadProfileData(completion: completion)
        state = .Finished
    }
    
    private let dataStore: IDataStore
}
