//
//  ImagePickerService.swift
//  TinkoffChat
//
//  Created by Evgeniy on 14.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import Foundation

protocol IImagePickerService
{
    func updateProfileImage(_ imageData: Data)
}

final class ImagePickerService: IImagePickerService
{
    // MARK: - IImagePickerService
    
    func updateProfileImage(_ imageData: Data)
    {
        
    }
    
    // MARK: - Private methods
    
    private func loadProfileModel() -> Profile?
    {
        let profile = fetchRequestProvider.profile()
        
        return coreDataWorker.executeFetchRequest(profile)?.first as? Profile
    }
    
    // MARK: - Private properties
    
    // MARK: Core objects
    
    private let coreDataWorker: ICoreDataWorker = CoreDataAssembly.coreDataWorker
    
    private let fetchRequestProvider: IFetchRequestProvider = CoreDataAssembly.fetchRequestProvider
}
