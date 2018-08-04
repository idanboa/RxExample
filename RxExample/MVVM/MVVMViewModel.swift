//
//  MVVMViewModel.swift
//  RxExample
//
//  Created by Idan Boadana on 8/3/18.
//  Copyright © 2018 Idan Boadana. All rights reserved.
//

import Foundation
import UIKit

typealias TextFieldAnimationValues = (value: CGFloat, duration: TimeInterval)

struct MVVMViewModel {
    // OUTPUT
    var animateTextField: ((TextFieldAnimationValues) -> Void)?
    var applyInput: ((String) -> Void)?
    var resignTextField: (() -> Void)?
    
    let title: String
    let inputDefaultText: String
    let inputFieldPlaceholder: String
    
    // INPUT
    var textFieldBottomConstraintOrigin: CGFloat = 0
    
    init(dependency: DependencyModel) {
        title = dependency.title
        inputDefaultText = dependency.inputDefaultText
        inputFieldPlaceholder = dependency.inputFieldPlaceholder
    }
    
    func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardFrame = userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue
        let keyboardHeight = (keyboardFrame?.cgRectValue.size.height ?? 0) + 10
        let animationDurationValue = userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSValue
        var animationDuration: TimeInterval = 0
        animationDurationValue?.getValue(&animationDuration)
        
        animateTextField?((keyboardHeight, animationDuration))
    }
    
    func keyboardWillHide(_ notification: Notification) {
        let userInfo = notification.userInfo
        let animationDurationValue = userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSValue
        var animationDuration: TimeInterval = 0
        animationDurationValue?.getValue(&animationDuration)
        
        animateTextField?((textFieldBottomConstraintOrigin, animationDuration))
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
        
        if newText.count == 0 {
            newText = inputDefaultText
        }
        
        applyInput?(newText)
        
        return true
    }
    
    func textFieldShouldReturn() -> Bool {
        resignTextField?()
        return true
    }
}
