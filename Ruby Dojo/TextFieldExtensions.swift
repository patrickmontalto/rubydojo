//
//  TextFieldExtensions.swift
//  Ruby Dojo
//
//  Created by Patrick Montalto on 6/14/16.
//  Copyright © 2016 swift. All rights reserved.
//

import UIKit

extension UITextField {
    func addLeftPadding(size: CGFloat) {
        let paddingView = UIView(frame: CGRectMake(0,0,size, self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = UITextFieldViewMode.Always
    }
}
