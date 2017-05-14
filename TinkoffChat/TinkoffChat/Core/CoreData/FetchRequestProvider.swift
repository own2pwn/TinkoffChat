//
//  FetchRequestProvider.swift
//  TinkoffChat
//
//  Created by Evgeniy on 08.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

// swiftlint:disable line_length

import UIKit
import CoreData

protocol IFetchRequestProvider
{
    func appUser() -> NSFetchRequest<NSFetchRequestResult>

    func conversationById(_ conversationId: String) -> NSFetchRequest<NSFetchRequestResult>

    func conversationByUserId(_ userId: String) -> NSFetchRequest<NSFetchRequestResult>

    func userById(_ userId: String) -> NSFetchRequest<NSFetchRequestResult>
}

final class FetchRequestProvider: IFetchRequestProvider
{
    // MARK: - IFetchRequestProvider

    func appUser() -> NSFetchRequest<NSFetchRequestResult>
    {
        let model = coreDataWorker.managedObjectModel
        let frt = model.fetchRequestTemplate(forName: KFetchRequestTemplates.AppUser)!
        return frt
    }

    func conversationById(_ conversationId: String) -> NSFetchRequest<NSFetchRequestResult>
    {
        let model = coreDataWorker.managedObjectModel
        let vars = ["conversationId": conversationId]
        let frt = model.fetchRequestFromTemplate(withName: KFetchRequestTemplates.ConversationById, substitutionVariables: vars)!
        frt.fetchLimit = 1

        return frt
    }

    func conversationByUserId(_ userId: String) -> NSFetchRequest<NSFetchRequestResult>
    {
        let model = coreDataWorker.managedObjectModel
        let vars = ["userId": userId]
        let frt = model.fetchRequestFromTemplate(withName: KFetchRequestTemplates.ConversationByUserId, substitutionVariables: vars)!
        frt.fetchLimit = 1

        return frt
    }

    func userById(_ userId: String) -> NSFetchRequest<NSFetchRequestResult>
    {
        let model = coreDataWorker.managedObjectModel
        let vars = ["userId": userId]
        let frt = model.fetchRequestFromTemplate(withName: KFetchRequestTemplates.UsersById, substitutionVariables: vars)!
        frt.fetchLimit = 1

        return frt
    }

    // MARK: - Life cycle

    init(coreDataWorker: ICoreDataWorker)
    {
        self.coreDataWorker = coreDataWorker
    }

    // MARK: - Private properties

    // MARK: Core objects

    private let coreDataWorker: ICoreDataWorker
}
