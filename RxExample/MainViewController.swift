//
//  ViewController.swift
//  RxExample
//
//  Created by Idan Boadana on 8/2/18.
//  Copyright © 2018 Idan Boadana. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

//    private var mvvmRxViewModel: MVVMRXViewModel!
    
    private struct Constants {
        static let inputDefaultText = "INPUT"
        static let inputFieldPlaceholder = "type something"
        
        struct MVC {
            static let segueID = "mvcSegueID"
            static let title = "MVC"
        }
        
        struct MVCRX {
            static let segueID = "mvcRxSegueID"
            static let title = "MVC-RX"
        }
        
        struct MVVM {
            static let segueID = "mvvmSegueID"
            static let title = "MVVM"
        }
        
        struct MVVMRX {
            static let segueID = "mvvmRxSegueID"
            static let title = "MVVM-RX"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Go To:"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Constants.MVC.segueID?:
            let model = DependencyModel(title: Constants.MVC.title,
                                        inputDefaultText: Constants.inputDefaultText,
                                        inputFieldPlaceholder: Constants.inputFieldPlaceholder)
            
            (segue.destination as? MVCViewController)?.model = model
        case Constants.MVCRX.segueID?:
            break
        case Constants.MVVM.segueID?:
            let model = DependencyModel(title: Constants.MVVM.title,
                                        inputDefaultText: Constants.inputDefaultText,
                                        inputFieldPlaceholder: Constants.inputFieldPlaceholder)
            let viewModel = MVVMViewModel(dependency: model)
            (segue.destination as? MVVMViewController)?.viewModel = viewModel
        case Constants.MVVMRX.segueID?:
            let model = DependencyModel(title: Constants.MVVMRX.title,
                                        inputDefaultText: Constants.inputDefaultText,
                                        inputFieldPlaceholder: Constants.inputFieldPlaceholder)
            let viewModel = MVVMRXViewModel(dependency: model)
            (segue.destination as? MVVMRXViewController)?.viewModel = viewModel
        default:
            break
        }
    }
    
    @IBAction func goToMVC() {
        performSegue(withIdentifier: Constants.MVC.segueID, sender: nil)
    }
    
    @IBAction func goToMVCRx() {
//        performSegue(withIdentifier: Constants.MVCRX.segueID, sender: nil)
    }
    
    @IBAction func goToMVVM() {
        performSegue(withIdentifier: Constants.MVVM.segueID, sender: nil)
    }
    
    @IBAction func goToMVVMRx() {
        performSegue(withIdentifier: Constants.MVVMRX.segueID, sender: nil)
    }
}

