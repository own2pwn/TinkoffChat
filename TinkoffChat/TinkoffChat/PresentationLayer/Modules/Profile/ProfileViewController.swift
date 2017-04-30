//
//  ProfileController.swift
//  TinkoffChat
//
//  Created by Evgeniy on 17.03.17.
//  Copyright © 2017 Evgeniy. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController
{
    // MARK: - Outlets

    @IBOutlet weak var userNameTextField: UITextField!

    @IBOutlet weak var aboutUserTextView: UITextView!

    @IBOutlet weak var userProfileImageView: UIImageView!

    @IBOutlet weak var textColorLabel: UILabel!

    @IBOutlet weak var saveProfileDataButton: UIButton!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Properties

    var onViewTapGesture = UITapGestureRecognizer()

    var onuserProfileImageViewTapGesture = UITapGestureRecognizer()

    var isProfileImageSet = false

    var savedProfileData = ProfileDisplayModel.getDefaultProfile()

    var currentProfileData = ProfileDisplayModel.getDefaultProfile()
    {
        didSet
        {
            setButtonsEnabled(currentProfileData != savedProfileData)
        }
    }

    // MARK: - Life cycle

    override func viewDidLoad()
    {
        super.viewDidLoad()

        activityIndicator.hidesWhenStopped = true

        setupLogic()
        model.load
        { profile, err in
            self.savedProfileData = profile
            self.currentProfileData = profile

            self.userNameTextField.text = profile.userName
            self.aboutUserTextView.text = profile.aboutUser
            self.userProfileImageView.image = profile.userImage

            if profile.userImage != #imageLiteral(resourceName: "profileImg") { self.isProfileImageSet = true }

            if err != nil
            {
                print("There was an error while loading profile data.\nError: \(String(describing: err?.localizedDescription))")
            }
        }
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
        updateCurrentProfileData()
    }

    @IBAction func didTapSaveButton(_ sender: UIButton)
    {
        let dataBeforeSaving = currentProfileData
        saveProfileData
        { bSuccess, err in
            self.presentSavingResultAlert(bSuccess)
            if bSuccess
            {
                self.savedProfileData = dataBeforeSaving
            }
            self.updateCurrentProfileData()
        }
    }

    @IBAction func didTapCloseNavBarButton(_ sender: UIBarButtonItem)
    {
        dismiss(animated: true, completion: nil)
    }

    func presentSavingResultAlert(_ success: Bool)
    {
        let alert = UIAlertController(title: "Данные сохранены", message: nil, preferredStyle: .alert)
        let dismissBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(dismissBtn)

        if !success
        {
            alert.title = "Ошибка"
            alert.message = "Не удалось сохранить данные"
            let retryBtn = UIAlertAction(title: "Повторить", style: .default, handler: { action in
                self.saveProfileData()
            })
            alert.addAction(retryBtn)
        }
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Data management

    func updateCurrentProfileData()
    {
        currentProfileData = ProfileDisplayModel(userName: userNameTextField.text ?? "",
                                                 aboutUser: aboutUserTextView.text,
                                                 userImage: userProfileImageView.image ?? #imageLiteral(resourceName: "profileImg"))
    }

    func setButtonsEnabled(_ enabled: Bool)
    {
        saveProfileDataButton.isEnabled = enabled

        if enabled
        {
            saveProfileDataButton.backgroundColor = .ButtonEnabledColor
        }
        else
        {
            saveProfileDataButton.backgroundColor = .ButtonDisabledColor
        }
    }

    func saveProfileData(completion: @escaping (Bool, Error?) -> Void = { _, _ in })
    {
        activityIndicator.startAnimating()
        model.save(profile: currentProfileData)
        { bSuccess, err in
            if err == nil
            {
                self.setButtonsEnabled(false)
            }
            self.activityIndicator.stopAnimating()
        }
    }

    func loadProfileData(usingManager manager: IDataStore, completion: @escaping (ProfileDisplayModel, Error?) -> Void)
    {
        activityIndicator.startAnimating()
        model.load
        { profile, err in
            completion(profile, err)
            self.activityIndicator.stopAnimating()
        }
    }

    // MARK: - Private properties

    private lazy var assembly: ProfileAssembly = {
        ProfileAssembly()
    }()

    private lazy var model: IProfileModel = {
        self.assembly.profileModel()
    }()
}

// MARK: - Extensions

// MARK: UITextFieldDelegate

extension ProfileViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()

        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField)
    {
        updateCurrentProfileData()
    }
}

// MARK: UITextViewDelegate

extension ProfileViewController: UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        let onViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(onViewTap))
        userProfileImageView.isUserInteractionEnabled = false
        view.addGestureRecognizer(onViewTapGesture)
        updateCurrentProfileData()
    }

    func textViewDidEndEditing(_ textView: UITextView)
    {
        updateCurrentProfileData()
    }

    func onViewTap()
    {
        aboutUserTextView.resignFirstResponder()
        if let onViewTapGesture = view.gestureRecognizers?.first
        {
            view.removeGestureRecognizer(onViewTapGesture)
        }
        userProfileImageView.isUserInteractionEnabled = true
        updateCurrentProfileData()
    }
}

// MARK: UIImagePickerControllerDelegate + UINavigationControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any])
    {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            userProfileImageView.image = pickedImage
            userProfileImageView.contentMode = .scaleAspectFit
            updateCurrentProfileData()

            isProfileImageSet = true
        }
        dismiss(animated: true, completion: nil)
    }
}
