//
//  TextBoxView.swift
//  Ruby Dojo
//
//  Created by Patrick Montalto on 6/14/16.
//  Copyright © 2016 swift. All rights reserved.
//

import UIKit

class TextBoxView: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.placeholder = "Tap me!"
        self.font = UIFont.systemFontOfSize(14)
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 1.0
        self.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = 4.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}