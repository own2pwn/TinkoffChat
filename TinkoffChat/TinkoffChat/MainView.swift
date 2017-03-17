//
//  ViewController.swift
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
    
    
    // MARK: - Properties
    
    var onViewTapGesture = UITapGestureRecognizer()
    
    
    // MARK: - Life cycle

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupLogic()
    }

    
    // MARK: - Methods
    
    func setupLogic()
    {
        userNameTF.delegate = self
        aboutUserTV.delegate = self
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
