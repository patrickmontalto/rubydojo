//
//  SyntaxTextContainer.swift
//  Ruby Dojo
//
//  Created by Patrick Montalto on 7/5/16.
//  Copyright © 2016 swift. All rights reserved.
//

import UIKit

class SyntaxTextContainer: NSTextContainer {
    override func lineFragmentRectForProposedRect(proposedRect: CGRect, atIndex characterIndex: Int, writingDirection baseWritingDirection: NSWritingDirection, remainingRect: UnsafeMutablePointer<CGRect>) -> CGRect {
        var rect = super.lineFragmentRectForProposedRect(proposedRect, atIndex: characterIndex, writingDirection: baseWritingDirection, remainingRect: remainingRect)
        
        let remainingRectSize = remainingRect.memory.size.height
        
        if remainingRectSize > 0 {
            rect.origin.x += 8
            rect.size.width -= 8
        }
        
        
        return rect
    }
}
