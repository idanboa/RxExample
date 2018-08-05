//
//  ViewController.swift
//  RxExample
//
//  Created by Idan Boadana on 8/2/18.
//  Copyright © 2018 Idan Boadana. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    private struct Constants {
        static let inputDefaultText = "INPUT"
        static let inputFieldPlaceholder = "type something"
        
        struct MVC {
            static let title = "MVC"
        }
        
        struct MVCRX {
            static let title = "MVC-RX"
        }
        
        struct MVVM {
            static let title = "MVVM"
        }
        
        struct MVVMRX {
            static let title = "MVVM-RX"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Go To:"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let mvcViewController as MVCViewController:
            let model = DependencyModel(title: Constants.MVC.title,
                                        inputDefaultText: Constants.inputDefaultText,
                                        inputFieldPlaceholder: Constants.inputFieldPlaceholder)
            mvcViewController.model = model
        case let mvcRXViewController as MVCRXViewController:
            let model = DependencyModel(title: Constants.MVCRX.title,
                                        inputDefaultText: Constants.inputDefaultText,
                                        inputFieldPlaceholder: Constants.inputFieldPlaceholder)
            mvcRXViewController.model = model
        case let mvvmViewController as MVVMViewController:
            let model = DependencyModel(title: Constants.MVVM.title,
                                        inputDefaultText: Constants.inputDefaultText,
                                        inputFieldPlaceholder: Constants.inputFieldPlaceholder)

            let viewModel = MVVMViewModel(dependency: model)
            mvvmViewController.viewModel = viewModel
        case let mvvmRXViewController as MVVMRXViewController:
            let model = DependencyModel(title: Constants.MVVMRX.title,
                                        inputDefaultText: Constants.inputDefaultText,
                                        inputFieldPlaceholder: Constants.inputFieldPlaceholder)

            let viewModel = MVVMRXViewModel(dependency: model)
            mvvmRXViewController.viewModel = viewModel
        default:
            break
        }
    }
}

