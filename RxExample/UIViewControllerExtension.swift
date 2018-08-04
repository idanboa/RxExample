//
//  UIViewControllerExtension.swift
//  RxExample
//
//  Created by Idan Boadana on 8/3/18.
//  Copyright © 2018 Idan Boadana. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func animateLayout(withDuration duration: TimeInterval) {
        UIView.animate(withDuration: duration) { [weak self] in
            guard let weakSelf = self else { return }
            
            weakSelf.view.layoutIfNeeded()
        }
    }
}
