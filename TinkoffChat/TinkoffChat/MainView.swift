//
//  MainView.swift
//  TinkoffChat
//
//  Created by Evgeniy on 17.03.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit

class MainView: UIViewController
{
    // MARK: - Outlets
    
    @IBOutlet weak var userNameTF: UITextField!
    
    @IBOutlet weak var aboutUserTV: UITextView!
    
    @IBOutlet weak var userProfileIV: UIImageView!
    
    // MARK: - Properties
    
    var onViewTapGesture = UITapGestureRecognizer()
    
    var onUserProfileIVTapGesture = UITapGestureRecognizer()
    
    var isProfileImageSet = false
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupLogic()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    
    // MARK: - Methods
    
    func setupLogic()
    {
        userNameTF.delegate = self
        aboutUserTV.delegate = self
        
        onUserProfileIVTapGesture = UITapGestureRecognizer(target: self, action: #selector(onUserProfileIVTap))
        userProfileIV.addGestureRecognizer(onUserProfileIVTapGesture)
    }
    
    
    func onUserProfileIVTap()
    {
        
        let profileImageActionActionSheet = UIAlertController(title: "Установить изображение профиля", message: "", preferredStyle: .actionSheet)
        
        let confirmDeleteAlertController = UIAlertController(title: "Удалить изображение профиля?", message: "Отменить это действие будет невозможно", preferredStyle: .alert)
        
        
        let chooseFromLibraryAction = UIAlertAction(title: "Выбрать из библиотеки", style: .default) { action in
            print(action)
        }
        
        let takePhotoAction = UIAlertAction(title: "Сделать фото", style: .default) { action in
            print(action)
        }
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        
        let deleteAction = UIAlertAction(title: "Удалить фото", style: .destructive) { action in
            
            let confirmDeleteAction = UIAlertAction(title: "Удалить", style: .destructive) { action in
                print(action)
            }
            
            confirmDeleteAlertController.addAction(cancelAction)
            confirmDeleteAlertController.addAction(confirmDeleteAction)
            
            self.present(confirmDeleteAlertController, animated: true, completion: nil)
            
        }
        
        profileImageActionActionSheet.addAction(chooseFromLibraryAction)
        profileImageActionActionSheet.addAction(takePhotoAction)
        profileImageActionActionSheet.addAction(deleteAction)
        profileImageActionActionSheet.addAction(cancelAction)
        
        self.present(profileImageActionActionSheet, animated: true, completion: nil)
    }
}


// MARK: - Extensions


// MARK: UITextFieldDelegate conformation

extension MainView: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        return true
    }
}


// MARK: UITextViewDelegate conformation

extension MainView: UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        onViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(onViewTap))
        self.view.addGestureRecognizer(onViewTapGesture)
    }
    
    func onViewTap()
    {
        self.aboutUserTV.resignFirstResponder()
        self.view.removeGestureRecognizer(onViewTapGesture)
    }
}

extension MainView
{
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
}
