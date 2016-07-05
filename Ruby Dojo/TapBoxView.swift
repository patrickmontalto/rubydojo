//
//  TapBoxView.swift
//  Ruby Dojo
//
//  Created by Patrick Montalto on 6/14/16.
//  Copyright © 2016 swift. All rights reserved.
//

import UIKit

class TapBoxView: UITextField {

    var blockActionMenu: Bool?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.font = UIFont.systemFontOfSize(14)
        self.layer.borderColor = UIColor.grayColor().CGColor
        self.layer.borderWidth = 1.0
        self.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = 4.0
        self.tintColor = UIColor.clearColor()
        self.backgroundColor = Solarized.BackgroundColor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        let actions: [Selector] = ["paste:", "select:", "selectAll:", "cut:", "copy:", "_define:", "_share:", "_promptForReplace:"]
        if actions.contains(action) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
}