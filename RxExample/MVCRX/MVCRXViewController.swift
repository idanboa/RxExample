//
//  MVCRXViewController.swift
//  RxExample
//
//  Created by Idan Boadana on 8/5/18.
//  Copyright © 2018 Idan Boadana. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MVCRXViewController: UIViewController {
    @IBOutlet weak var inputLabel: UILabel!
    
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
    private var textFieldBottomConstraintOrigin: CGFloat!
    @IBOutlet weak var textField: UITextField!
    
    var model: DependencyModel!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldBottomConstraintOrigin = textFieldBottomConstraint.constant
        
        title = model?.title
        inputLabel.text = model?.inputDefaultText
        textField.placeholder = model?.inputFieldPlaceholder
        
        let showKeyboardNotification = NotificationCenter
            .default
            .rx
            .notification(.UIKeyboardWillShow)
            .map { notification in (KeyboardEvent.show, notification) }
            .asDriver(onErrorDriveWith: Driver.never())
        
        let hideKeyboardNotification = NotificationCenter
            .default
            .rx
            .notification(.UIKeyboardWillHide)
            .map { notification in (KeyboardEvent.hide, notification) }
            .asDriver(onErrorDriveWith: Driver.never())
        
        Driver
            .merge(showKeyboardNotification, hideKeyboardNotification)
            .drive(onNext: { [weak self] (type, notification) in
                guard let weakSelf = self else { return }
                
                let userInfo = notification.userInfo
                let animationDurationValue = userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSValue
                var animationDuration: TimeInterval = 0
                animationDurationValue?.getValue(&animationDuration)
                
                let keyboardHeight: CGFloat
                
                switch type {
                case .show:
                    let keyboardFrame = userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue
                    keyboardHeight = (keyboardFrame?.cgRectValue.size.height ?? 0) + 10
                case .hide:
                    keyboardHeight = weakSelf.textFieldBottomConstraintOrigin
                }
                    
                weakSelf.textFieldBottomConstraint.constant = keyboardHeight
                weakSelf.animateLayout(withDuration: animationDuration)
            })
            .disposed(by: bag)
        
        textField
            .rx
            .text
            .orEmpty
            .asDriver(onErrorJustReturn: model.inputDefaultText)
            .map { [weak self] text in return text.count == 0 ? self?.model.inputDefaultText ?? "" : text }
            .drive(inputLabel.rx.text)
            .disposed(by: bag)
    }
}

