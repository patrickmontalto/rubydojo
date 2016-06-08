//
//  CourseViewController.swift
//  Ruby Dojo
//
//  Created by Patrick Montalto on 6/6/16.
//  Copyright © 2016 swift. All rights reserved.
//

import UIKit

class CourseViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = "Hello, this is a test. 'TEXTBOX'"
        let textboxRange = textView.text.rangeOfString("TEXTBOX")!
        
        let offset1 = textView.text.startIndex.distanceTo(textboxRange.startIndex)
        let offset2 = textView.text.startIndex.distanceTo(textboxRange.endIndex)
        
        let pos2: UITextPosition = textView.positionFromPosition(textView.beginningOfDocument, offset: Int(offset2))!
        let pos1: UITextPosition = textView.positionFromPosition(textView.beginningOfDocument, offset: offset1)!
        print("pos1: \(pos1), pos2: \(pos2)")
        let range: UITextRange = textView.textRangeFromPosition(pos1, toPosition: pos2)!
        
        let resultFrame: CGRect = textView.firstRectForRange(range)
        
        let finalFrame = CGRect(x: resultFrame.origin.x, y: resultFrame.origin.y, width: 80, height: 18)
        
        print("x:\(resultFrame.origin.x), y:\(resultFrame.origin.y)")
        
        let textField = UITextField(frame: finalFrame)
        textField.placeholder = "Hello!"
        textField.font = UIFont.systemFontOfSize(14)
        textField.layer.borderColor = UIColor.blackColor().CGColor
        textField.layer.borderWidth = 1.0
        textField.backgroundColor = UIColor.whiteColor()
        textView.addSubview(textField)
        // Replace TEXTBOX with blanks
//
//        let newView = UIView.init(frame: resultFrame)
//        
//        newView.backgroundColor = UIColor
    }

}

