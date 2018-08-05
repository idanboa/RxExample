//
//  MVVMRXViewController.swift
//  RxExample
//
//  Created by Idan Boadana on 8/3/18.
//  Copyright © 2018 Idan Boadana. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MVVMRXViewController: UIViewController {
    @IBOutlet private var inputLabel: UILabel!
    @IBOutlet private var textFieldBottomConstraint: NSLayoutConstraint!
    @IBOutlet private var textField: UITextField!
    
    var viewModel: MVVMRXViewModel!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.becomeFirstResponder()
        bindViewModel()
    }
    
    func bindViewModel() {
        viewModel
            .title
            .drive(onNext: { [weak self] titleText in
                self?.title = titleText
            })
            .disposed(by: bag)
        
        viewModel
            .inputDefaultText
            .drive(inputLabel.rx.text)
            .disposed(by: bag)
        
        viewModel
            .inputFieldPlaceholder
            .drive(onNext: { [weak self] placeholder in
                self?.textField.placeholder = placeholder
            })
            .disposed(by: bag)
        
        viewModel.textFieldBottomConstraintOrigin.value = textFieldBottomConstraint.constant
        
        let showKeyboardNotification = NotificationCenter
            .default
            // this is a reactive extension for NotificationCenter that emits events when the notification fires, it passes along the notification itself :)
            .rx
            .notification(.UIKeyboardWillShow)
            .map { notification in (KeyboardEvent.show, notification) }
        
        let hideKeyboardNotification = NotificationCenter
            .default
            .rx
            .notification(.UIKeyboardWillHide)
            .map { notification in (KeyboardEvent.hide, notification) }
        
        // http://rxmarbles.com/#merge
        Observable
            .merge(showKeyboardNotification, hideKeyboardNotification)
            .bind(to: viewModel.keyboardEvent)
            .disposed(by: bag)
        
        viewModel
            .animateTextField
            .map { $0.0 } // <- a stream that filters out only the animation value
            .drive(textFieldBottomConstraint.rx.constant)
            .disposed(by: bag)
        
        viewModel
            .animateTextField
            .map { $0.1 } // <- a stream that filters out only the animation duration
            .drive(onNext: { [weak self] duration in
                self?.animateLayout(withDuration: duration)
                },
                   onDisposed: {
                    print("i am the 'animateTextField' stream and i have just been disposed of because the dispose bag that was assigned to me was dealocated when the view controller was dealocated.. \n** we must remember to bind/subscribe only inside views because subscribing keeps the object it was subscribed in alive!")
            })
            .disposed(by: bag)
        
        // this is a reactive extension for UITextField that emits events when the text has changed, so we dont need a delegate method for it,
        textField
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.textInputSubject)
            .disposed(by: bag)
        
        viewModel
            .applyInput
            .drive(inputLabel.rx.text)
            .disposed(by: bag)
    }
}
