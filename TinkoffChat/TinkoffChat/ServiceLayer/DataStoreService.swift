//
//  DataStoreService.swift
//  TinkoffChat
//
//  Created by Evgeniy on 08.05.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit

protocol IDataStoreService
{
    func saveImageOnDisk(_ image: UIImage,
                         completion: @escaping (Error?, String?) -> Void)

    func getImageFromDisk(by path: String) -> UIImage?
}

enum DataStoreError: Error
{
    case cantRepresentImage
}

final class DataStoreService: IDataStoreService
{
    // MARK: - IDataStoreService

    func saveImageOnDisk(_ image: UIImage,
                         completion: @escaping (Error?, String?) -> Void)
    {
        if let imageData = UIImagePNGRepresentation(image)
        {
            do
            {
                try imageData.write(to: userImagePath)
                completion(nil, userImageName)
            }
            catch
            {
                completion(error, nil)
            }
        }
        else
        {
            let error = DataStoreError.cantRepresentImage
            completion(error, nil)
        }
    }

    func getImageFromDisk(by path: String) -> UIImage?
    {
        let filePath = getDocumentsDir().appendingPathComponent(path)
        if let imageData = try? Data(contentsOf: filePath)
        {
            return UIImage(data: imageData)
        }
        return nil
    }

    // MARK: - Private methods

    private func getDocumentsDir() -> URL
    {
        return FileManager.default.urls(for: .documentDirectory,
                                        in: .userDomainMask).first!
    }

    // MARK: - Private properties

    private lazy var userImagePath: URL = {
        let docsDir = self.getDocumentsDir()
        let filePath = docsDir.appendingPathComponent(self.userImageName)

        return filePath
    }()

    private let userImageName = "profileImage.bin"
}
