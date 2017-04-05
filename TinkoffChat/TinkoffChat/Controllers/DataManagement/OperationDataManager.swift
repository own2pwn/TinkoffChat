//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by Evgeniy on 05.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit

class OperationDataManager: DataManager
{
    func saveProfileData(_ profile: Profile, completion: @escaping (Bool, Error?) -> Void)
    {
        let queue = OperationQueue()
        queue.qualityOfService = .userInitiated

        let op = SaveProfileDataOperation(profile, completion: { bSuccess, err in
            OperationQueue.main.addOperation
            {
                completion(bSuccess, err)
            }
        })
        queue.addOperation(op)
    }

    func loadProfileData(completion: @escaping (Profile, Error?) -> Void)
    {
        let queue = OperationQueue()
        queue.qualityOfService = .userInitiated

        let op = LoadProfileDataOperation(completion: { profile, err in
            OperationQueue.main.addOperation
            {
                completion(profile, err)
            }
        })
        queue.addOperation(op)
    }
}

class AsyncOperation: Operation
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

class SaveProfileDataOperation: AsyncOperation
{
    let profile: Profile
    let completion: (Bool, Error?) -> Void

    init(_ profile: Profile, completion: @escaping (Bool, Error?) -> Void)
    {
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
        DataStore.saveProfileData(profile, completion: completion)
        state = .Finished
    }
}

class LoadProfileDataOperation: AsyncOperation
{
    let completion: (Profile, Error?) -> Void

    init(completion: @escaping (Profile, Error?) -> Void)
    {
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
        DataStore.loadProfileData(completion: completion)
        state = .Finished
    }
}
