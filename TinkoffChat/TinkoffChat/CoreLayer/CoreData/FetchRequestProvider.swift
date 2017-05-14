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

    var userFRC: NSFetchedResultsController<NSFetchRequestResult> { get }

    func messageInConversationFRC(_ senderId: String,
                                  delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<NSFetchRequestResult>

    func setDelegateForUserFRC(_ delegate: NSFetchedResultsControllerDelegate)

    func setDelegateForMessageInConversationFRC(_ delegate: NSFetchedResultsControllerDelegate)
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

    lazy var userFRC: NSFetchedResultsController<NSFetchRequestResult> = {
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let localUserId = UIDevice.current.identifierForVendor!.uuidString

        let onlineSorter = NSSortDescriptor(key: "isOnline", ascending: false)
        let nameSorter = NSSortDescriptor(key: "name", ascending: false)

        let sortDescriptors = [onlineSorter, nameSorter]

        let predicate = NSPredicate(format: "userId != %@", localUserId)

        fr.sortDescriptors = sortDescriptors
        fr.predicate = predicate

        let frc: NSFetchedResultsController<NSFetchRequestResult> = NSFetchedResultsController(fetchRequest: fr,
                                                                                               managedObjectContext: self.coreDataWorker.mainCtx,
                                                                                               sectionNameKeyPath: #keyPath(User.isOnline),
                                                                                               cacheName: nil)
        return frc
    }()

    func messageInConversationFRC(_ senderId: String,
                                  delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<NSFetchRequestResult>
    {
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
        let predicate = NSPredicate(format: "sender.userId == %@ || receiver.userId == %@", senderId, senderId)
        let nameSorter = NSSortDescriptor(key: "orderIndex", ascending: false)

        fr.sortDescriptors = [nameSorter]
        fr.predicate = predicate

        let frc: NSFetchedResultsController<NSFetchRequestResult> = NSFetchedResultsController(fetchRequest: fr,
                                                                                               managedObjectContext: coreDataWorker.mainCtx,
                                                                                               sectionNameKeyPath: nil,
                                                                                               cacheName: nil)
        messageInConversation = frc

        return frc
    }

    private var messageInConversation: NSFetchedResultsController<NSFetchRequestResult>!

    func setDelegateForUserFRC(_ delegate: NSFetchedResultsControllerDelegate)
    {
        userFRC.delegate = delegate
    }

    func setDelegateForMessageInConversationFRC(_ delegate: NSFetchedResultsControllerDelegate)
    {
        messageInConversation.delegate = delegate
    }

    // MARK: - Life cycle

    init(coreDataWorker: ICoreDataWorker)
    {
        self.coreDataWorker = coreDataWorker
    }

    // MARK: - Private properties

    private let coreDataWorker: ICoreDataWorker
}
