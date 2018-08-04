//
//  MVVMViewController.swift
//  RxExample
//
//  Created by Idan Boadana on 8/3/18.
//  Copyright © 2018 Idan Boadana. All rights reserved.
//

import Foundation
import UIKit

class MVVMViewController: UIViewController {
    @IBOutlet weak var inputLabel: UILabel!
    
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textField: UITextField!
    
    var viewModel: MVVMViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.title
        inputLabel.text = viewModel.inputDefaultText
        textField.placeholder = viewModel.inputFieldPlaceholder
        
        viewModel.textFieldBottomConstraintOrigin = textFieldBottomConstraint.constant
        
        bindViewModel()
        
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(keyboardWillShow),
                         name: NSNotification.Name.UIKeyboardWillShow,
                         object: nil)
        
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(keyboardWillHide),
                         name: NSNotification.Name.UIKeyboardWillHide,
                         object: nil)
        
        textField.delegate = self
    }
    
    func bindViewModel() {
        viewModel.animateTextField = { [weak self] animationValues in
            self?.textFieldBottomConstraint.constant = animationValues.value
            self?.animateLayout(withDuration: animationValues.duration)
        }
        
        viewModel.applyInput = { text in
            DispatchQueue.main.async { [weak self] in
                self?.inputLabel.text = text
            }
        }
        
        viewModel.resignTextField = { [weak self] in
            self?.textField.resignFirstResponder()
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        viewModel.keyboardWillShow(notification)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        viewModel.keyboardWillHide(notification)
    }
}

extension MVVMViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return viewModel.textField(textField,
                                   shouldChangeCharactersIn: range,
                                   replacementString: string)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return viewModel.textFieldShouldReturn()
    }
}
