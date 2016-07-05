//
//  UIViewControllerExtensions.swift
//  Ruby Dojo
//
//  Created by Patrick Montalto on 7/5/16.
//  Copyright © 2016 swift. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func dismissRespondersOnTapOut() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeybord))
        view.addGestureRecognizer(tapGesture)
    }
    func dismissKeybord() {
        view.endEditing(true)
    }
}