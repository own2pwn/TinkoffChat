//
//  ProfileController.swift
//  TinkoffChat
//
//  Created by Evgeniy on 17.03.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit

class ProfileController: UIViewController
{
    // MARK: - Outlets
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var aboutUserTextView: UITextView!
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    
    @IBOutlet weak var textColorLabel: UILabel!
    
    // MARK: - Properties
    
    var onViewTapGesture = UITapGestureRecognizer()
    
    var onuserProfileImageViewTapGesture = UITapGestureRecognizer()
    
    var isProfileImageSet = false
    
    // MARK: - Life cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupLogic()
    }
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    // MARK: - Methods
    
    func setupLogic()
    {
        userNameTextField.delegate = self
        aboutUserTextView.delegate = self
        
        onuserProfileImageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(onuserProfileImageViewTap))
        userProfileImageView.addGestureRecognizer(onuserProfileImageViewTapGesture)
    }
    
    func onuserProfileImageViewTap()
    {
        
        let profileImageActionActionSheet = UIAlertController(title: "Установить изображение профиля", message: "", preferredStyle: .actionSheet)
        
        let confirmDeleteAlertController = UIAlertController(title: "Удалить изображение профиля?", message: "Отменить это действие будет невозможно", preferredStyle: .alert)
        
        let chooseFromLibraryAction = UIAlertAction(title: "Выбрать из библиотеки", style: .default)
        { action in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let takePhotoAction = UIAlertAction(title: "Сделать фото", style: .default)
        { action in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .camera
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        
        let deleteAction = UIAlertAction(title: "Удалить фото", style: .destructive)
        { action in
            let confirmDeleteAction = UIAlertAction(title: "Удалить", style: .destructive)
            { action in
                self.userProfileImageView.image = #imageLiteral(resourceName: "profileImg")
                self.isProfileImageSet = false
            }
            
            confirmDeleteAlertController.addAction(cancelAction)
            confirmDeleteAlertController.addAction(confirmDeleteAction)
            
            self.present(confirmDeleteAlertController, animated: true, completion: nil)
            
        }
        
        profileImageActionActionSheet.addAction(chooseFromLibraryAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) { profileImageActionActionSheet.addAction(takePhotoAction) }
        
        if isProfileImageSet { profileImageActionActionSheet.addAction(deleteAction) }
        
        profileImageActionActionSheet.addAction(cancelAction)
        
        present(profileImageActionActionSheet, animated: true, completion: nil)
    }
    
    @IBAction func didTapColorButton(_ sender: UIButton)
    {
        textColorLabel.textColor = sender.backgroundColor
    }
    
    @IBAction func didTapSaveButton(_ sender: UIButton)
    {
        print("Сохранение данных профиля")
    }
    @IBAction func didTapCloseNavBarButton(_ sender: UIBarButtonItem)
    {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extensions

// MARK: UITextFieldDelegate

extension ProfileController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        return true
    }
}

// MARK: UITextViewDelegate

extension ProfileController: UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        onViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(onViewTap))
        userProfileImageView.isUserInteractionEnabled = false
        view.addGestureRecognizer(onViewTapGesture)
    }
    
    func onViewTap()
    {
        aboutUserTextView.resignFirstResponder()
        view.removeGestureRecognizer(onViewTapGesture)
        userProfileImageView.isUserInteractionEnabled = true
    }
}

// MARK: UIImagePickerControllerDelegate + UINavigationControllerDelegate

extension ProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any])
    {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            userProfileImageView.image = pickedImage
            userProfileImageView.contentMode = .scaleAspectFit
            
            isProfileImageSet = true
        }
        dismiss(animated: true, completion: nil)
    }
}
