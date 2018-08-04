//
//  MVVMRXViewModel.swift
//  RxExample
//
//  Created by Idan Boadana on 8/3/18.
//  Copyright © 2018 Idan Boadana. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

enum KeyboardEvent {
    case show
    case hide
}

struct MVVMRXViewModel {
    // OUTPUT
    let title: Driver<String>
    let inputDefaultText: Driver<String>
    let inputFieldPlaceholder: Driver<String>
    
    let animateTextField: Driver<TextFieldAnimationValues>
    let applyInput: Driver<String>
    
    // INPUT
    let textFieldBottomConstraintOrigin = Variable<CGFloat>(0)
    
    // *1)
    // private publishSubjects so that we are not exposing observations.
    private let keyboardEventSubject = PublishSubject<(KeyboardEvent, Notification)>()
    // we only wish to expose the 'trigger' and not the observable.
    let keyboardEvent: AnyObserver<(KeyboardEvent, Notification)>
    
    // *2)
    // another option is to expose both the trigger and the observation, this breaks encapsulation in most cases, the upside is that we do not need another variable like in *1.
    let textInputSubject = PublishSubject<String?>()
    
    init(dependency: DependencyModel) {
        title = Driver.of(dependency.title)
        inputDefaultText = Driver.of(dependency.inputDefaultText)
        inputFieldPlaceholder = Driver.of(dependency.inputFieldPlaceholder)
        
        keyboardEvent = keyboardEventSubject.asObserver()
        
        let keyboardShow: Driver<TextFieldAnimationValues> = keyboardEventSubject
            .filter { $0.0 == .show }
            .map { (_, notification) in
                let userInfo = notification.userInfo
                let keyboardFrame = userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue
                let keyboardHeight = (keyboardFrame?.cgRectValue.size.height ?? 0) + 10
                let animationDurationValue = userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSValue
                var animationDuration: TimeInterval = 0
                animationDurationValue?.getValue(&animationDuration)
                
                return (keyboardHeight, animationDuration)
        }
        .asDriver(onErrorJustReturn: (0, 0))
        
        let keyboardHide: Driver<TextFieldAnimationValues> = keyboardEventSubject
            .filter { $0.0 == .hide }
            .withLatestFrom(textFieldBottomConstraintOrigin.asObservable()) { (eventValues, constraintValue) in
                // with latest from has a block to map what values we want from each observable.
                return (eventValues.1, constraintValue)
            }
            .map { (notification, constraintValue) in
                let userInfo = notification.userInfo
                let animationDurationValue = userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSValue
                var animationDuration: TimeInterval = 0
                animationDurationValue?.getValue(&animationDuration)
                
                return (constraintValue, animationDuration)
            }
            .asDriver(onErrorJustReturn: (0, 0))
            .asSharedSequence()
        
        animateTextField = Driver
            .merge(keyboardShow, keyboardHide)

        applyInput = textInputSubject
            .asDriver(onErrorJustReturn: nil)
            // with latest from has a block to map what values we want from each observable.
            .withLatestFrom(inputDefaultText) { ($0, $1) }
            .map { (newText, defaultText) in
                guard let newText = newText, newText.count > 0 else {
                    return defaultText
                }
                
                return newText
        }
    }
}
