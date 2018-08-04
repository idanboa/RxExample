//
//  MVCViewController.swift
//  RxExample
//
//  Created by Idan Boadana on 8/2/18.
//  Copyright © 2018 Idan Boadana. All rights reserved.
//

import Foundation
import UIKit

class MVCViewController: UIViewController {    
    @IBOutlet weak var inputLabel: UILabel!
    
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
    private var textFieldBottomConstraintOrigin: CGFloat!
    @IBOutlet weak var textField: UITextField!
    
    var model: DependencyModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldBottomConstraintOrigin = textFieldBottomConstraint.constant
        
        title = model?.title
        inputLabel.text = model?.inputDefaultText
        textField.placeholder = model?.inputFieldPlaceholder
        
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
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardFrame = userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue
        let keyboardHeight = (keyboardFrame?.cgRectValue.size.height ?? 0) + 10
        let animationDurationValue = userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSValue
        var animationDuration: TimeInterval = 0
        animationDurationValue?.getValue(&animationDuration)
        
        textFieldBottomConstraint.constant = keyboardHeight
        animateLayout(withDuration: animationDuration)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        let userInfo = notification.userInfo
        let animationDurationValue = userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSValue
        var animationDuration: TimeInterval = 0
        animationDurationValue?.getValue(&animationDuration)
        
        textFieldBottomConstraint.constant = textFieldBottomConstraintOrigin
        animateLayout(withDuration: animationDuration)
    }
}

extension MVCViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
    
        if newText.count == 0 {
            newText = model.inputDefaultText
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.inputLabel.text = newText
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
