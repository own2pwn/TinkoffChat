//
//  CoreDataAssembly.swift
//  TinkoffChat
//
//  Created by Evgeniy on 13.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

protocol ICoreDataWorkerInjectable: class
{
    var coreDataWorker: ICoreDataWorker { get set }
}

protocol IFetchRequestProviderInjectable: class
{
    var fetchRequestProvider: IFetchRequestProvider { get set }
}

protocol ICoreDataAssembly
{
    static var coreDataWorker: ICoreDataWorker { get }

    static var fetchRequestProvider: IFetchRequestProvider { get }

    static func injectCoreDataWorker(to object: ICoreDataWorkerInjectable)

    static func injectFetchRequestProvider(to object: IFetchRequestProviderInjectable)
}

final class CoreDataAssembly: ICoreDataAssembly
{
    // MARK: - ICoreDataAssembly

    static func injectCoreDataWorker(to object: ICoreDataWorkerInjectable)
    {
        object.coreDataWorker = coreDataWorker
    }

    static func injectFetchRequestProvider(to object: IFetchRequestProviderInjectable)
    {
        object.fetchRequestProvider = fetchRequestProvider
    }

    // MARK: - Private properties

    // MARK: Core objects

    static var coreDataWorker: ICoreDataWorker = CoreDataWorker()

    static var fetchRequestProvider: IFetchRequestProvider = FetchRequestProvider(coreDataWorker: coreDataWorker)
}
