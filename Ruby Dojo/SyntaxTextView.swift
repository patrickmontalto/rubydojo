//
//  SyntaxTextView.swift
//  Ruby Dojo
//
//  Created by Patrick Montalto on 7/7/16.
//  Copyright © 2016 swift. All rights reserved.
//

import UIKit

// MARK: - Service object which creates syntax highlighted UITextViews
class SyntaxTextViewCreator {
    
    class func createWithText(text: String, view: UIView) -> UITextView {
        
        // 1. Create the text storage that backs the editor
        let attrs = [NSFontAttributeName : Solarized.Font, NSForegroundColorAttributeName: Solarized.Base02]
        let attrString = NSAttributedString(string: text, attributes: attrs)
        let textStorage = SyntaxHighlightingTextStorage()
        textStorage.appendAttributedString(attrString)
        
        let newTextViewRect = view.bounds
        
        // 2. Create the layout manager
        let layoutManager = SyntaxLayoutManager()
        
        // 3. Create a text container
        let containerSize = CGSize(width: newTextViewRect.width, height: CGFloat.max)
        let container = SyntaxTextContainer(size: containerSize)
        
        layoutManager.addTextContainer(container)
        textStorage.addLayoutManager(layoutManager)
        
        // 4. Create a UITextView
        let textView = UITextView(frame: newTextViewRect, textContainer: container)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        // 5. Substitute two spaces for tab characters
        
        textView.text = textView.text.stringByReplacingOccurrencesOfString("\t", withString: "  ")
        
        return textView
    }
    
}
