//
//  FetchedResultsControllerProviderService.swift
//  TinkoffChat
//
//  Created by Evgeniy on 14.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

// swiftlint:disable line_length

import CoreData

protocol IFetchedResultsControllerProviderService
{
    func userFetchedResultsController(_ localUserId: String,
                                      _ delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<User>
    
    func messageFetchedResultsController(_ participant: User,
                                         _ delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<Message>
}

final class FetchedResultsControllerProviderService: IFetchedResultsControllerProviderService
{
    // MARK: - IFetchedResultsControllerProviderService
    
    func userFetchedResultsController(_ localUserId: String,
                                      _ delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<User>
    {
        let fr = NSFetchRequest<User>(entityName: "User")
        let onlineSorter = NSSortDescriptor(key: "isOnline", ascending: false)
        let nameSorter = NSSortDescriptor(key: "name", ascending: false)
        
        let sortDescriptors = [onlineSorter, nameSorter]
        let predicate = NSPredicate(format: "userId != %@", localUserId)
        
        fr.sortDescriptors = sortDescriptors
        fr.predicate = predicate
        
        let frc = NSFetchedResultsController(fetchRequest: fr,
                                             managedObjectContext: coreDataWorker.mainCtx,
                                             sectionNameKeyPath: #keyPath(User.isOnline),
                                             cacheName: nil)
        frc.delegate = delegate
        
        // swiftlint:disable force_try
        try! frc.performFetch()
        
        return frc
    }
    
    func messageFetchedResultsController(_ participant: User,
                                         _ delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<Message>
    {
        let fr = NSFetchRequest<Message>(entityName: "Message")
        let predicate = NSPredicate(format: "sender == %@ || receiver == %@", participant, participant)
        let nameSorter = NSSortDescriptor(key: "orderIndex", ascending: false)
        
        fr.sortDescriptors = [nameSorter]
        fr.predicate = predicate
        
        let frc = NSFetchedResultsController(fetchRequest: fr,
                                             managedObjectContext: coreDataWorker.mainCtx,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        
        frc.delegate = delegate
        try! frc.performFetch()
        // swiftlint:enable force_try
        
        return frc
    }
    
    // MARK: - Private properties
    
    private let coreDataWorker: ICoreDataWorker = CoreDataAssembly.coreDataWorker
}

// swiftlint:enable line_length
