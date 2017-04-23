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

    func saveProfileData(_ profile: ProfileDisplayModel, completion: @escaping (Bool, Error?) -> Void)
    {
        let op = SaveProfileDataOperation(dataStore: dataStore, profile, completion: { bSuccess, err in
            OperationQueue.main.addOperation
            {
                completion(bSuccess, err)
            }
        })

        queue.addOperation(op)
    }

    func loadProfileData(completion: @escaping (ProfileDisplayModel, Error?) -> Void)
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
        case ready, executing, finished
        var keyPath: String
        {
            return "is" + self.rawValue
        }
    }

    var state = State.ready
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

    override var isExecuting: Bool { return state == .executing }

    override var isFinished: Bool { return state == .finished }
}

private class SaveProfileDataOperation: AsyncOperation
{
    let profile: ProfileDisplayModel
    let completion: (Bool, Error?) -> Void

    init(dataStore: IDataStore, _ profile: ProfileDisplayModel, completion: @escaping (Bool, Error?) -> Void)
    {
        self.dataStore = dataStore
        self.profile = profile
        self.completion = completion
    }

    override func start()
    {
        if isCancelled
        {
            state = .finished
            return
        }
        state = .executing
        dataStore.saveProfileData(profile, completion: completion)
        state = .finished
    }

    private let dataStore: IDataStore
}

private class LoadProfileDataOperation: AsyncOperation
{
    let completion: (ProfileDisplayModel, Error?) -> Void

    init(dataStore: IDataStore, completion: @escaping (ProfileDisplayModel, Error?) -> Void)
    {
        self.dataStore = dataStore
        self.completion = completion
    }

    override func start()
    {
        if isCancelled
        {
            state = .finished
            return
        }
        state = .executing
        dataStore.loadProfileData(completion: completion)
        state = .finished
    }

    private let dataStore: IDataStore
}
