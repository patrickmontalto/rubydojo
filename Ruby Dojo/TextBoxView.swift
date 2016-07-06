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
        self.font = Solarized.Font
        self.layer.borderColor = UIColor.grayColor().CGColor
        self.layer.borderWidth = 0.5
        self.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = 4.0
        self.backgroundColor = Solarized.BackgroundColor
        self.textColor = Solarized.RedColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}