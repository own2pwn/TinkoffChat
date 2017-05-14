//
//  ConversationsListModel.swift
//  TinkoffChat
//
//  Created by Evgeniy on 22.04.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation
import CoreData

protocol IConversationsListModel: class
{
    func initFetchedResultsController(ignoringUserId: String, _ delegate: NSFetchedResultsControllerDelegate)

    var numberOfSection: Int { get }

    func getTitleForSection(_ section: Int) -> String

    func numberOfRowsInSection(_ section: Int) -> Int

    func fetchUserDisplayModel(at indexPath: IndexPath) -> UserDisplayModel

    func fetchUser(at indexPath: IndexPath) -> User
}

final class ConversationsListModel: IConversationsListModel
{
    // MARK: - IConversationsListModel

    func initFetchedResultsController(ignoringUserId: String, _ delegate: NSFetchedResultsControllerDelegate)
    {
        userFRC = frcProviderService.userFetchedResultsController(ignoringUserId, delegate)
    }

    var numberOfSection: Int
    {
        return userFRC.sections?.count ?? 0
    }

    func getTitleForSection(_ section: Int) -> String
    {
        // swiftlint:disable:next force_cast
        let isAnyoneOnline = userFRC.fetchedObjects!
            .contains(where: { $0.isOnline == true })

        if isAnyoneOnline && section == 0
        {
            return "Online"
        }
        return "History"
    }

    func numberOfRowsInSection(_ section: Int) -> Int
    {
        if let sections = userFRC.sections
        {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }

    func fetchUserDisplayModel(at indexPath: IndexPath) -> UserDisplayModel
    {
        let user = userFRC.object(at: indexPath)
        let userName = user.name
        let online = user.isOnline
        let conversationWithUser = user.conversations?.allObjects.first as? Conversation
        let lastMessage = conversationWithUser?.lastMessage?.text
        let lastMessageDate = conversationWithUser?.lastMessage?.date

        let displayModel = UserDisplayModel(name: userName,
                                            isOnline: online,
                                            lastMessageText: lastMessage,
                                            lastMessageDate: lastMessageDate as Date?)
        return displayModel
    }

    func fetchUser(at indexPath: IndexPath) -> User
    {
        return userFRC.object(at: indexPath)
    }

    // MARK: - Life cycle

    init(mpcService: IMPCService,
         frcProviderService: IFetchedResultsControllerProviderService)
    {
        self.mpcService = mpcService
        self.frcProviderService = frcProviderService
    }

    // MARK: - Private properties

    private var userFRC: NSFetchedResultsController<User>!

    // MARK: Services

    private let mpcService: IMPCService

    private let frcProviderService: IFetchedResultsControllerProviderService
}
