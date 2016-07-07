//
//  SyntaxLayoutManager.swift
//  Ruby Dojo
//
//  Created by Patrick Montalto on 7/5/16.
//  Copyright © 2016 swift. All rights reserved.
//

import UIKit

class SyntaxLayoutManager: NSLayoutManager {
    
    // MARK: - Paragraph Numbers
    override func drawBackgroundForGlyphRange(glyphsToShow: NSRange, atPoint origin: CGPoint) {
        super.drawBackgroundForGlyphRange(glyphsToShow, atPoint: origin)
        
        // Iterate over all lines we should be drawing
        var glyphIndex = glyphsToShow.location
        var paragraphNumber = 1

        while (glyphIndex < NSMaxRange(glyphsToShow)) {
            // Declare glyph line range variable
            var glyphLineRange = NSRange()
            
            // Get rectangle for the line we are in
            let lineRect = lineFragmentRectForGlyphAtIndex(glyphIndex, effectiveRange: &glyphLineRange)
            
            // Check for paragraph start
            let lineRange = characterRangeForGlyphRange(glyphLineRange, actualGlyphRange: nil)
            let paragraphRange = (textStorage!.string as NSString).paragraphRangeForRange(lineRange)
            
            // Draw paragraph number if we're at the start of the paragraph
            if lineRange.location == paragraphRange.location {
                drawParagraphNumber(paragraphNumber, lineFragmentRect: lineRect, atPoint: origin)
                // Advance paragraph number for next time we're at start of paragraph
                paragraphNumber += 1
            }
            
            // Advance Index
            glyphIndex = NSMaxRange(glyphLineRange)
        }
    }
    
    // MARK: - Draw Paragraph Numbers
    func drawParagraphNumber(paragraphNumber: Int, lineFragmentRect lineRect:CGRect, atPoint origin: CGPoint) {
        let numberStringAttributes: [String:AnyObject] = [
            NSForegroundColorAttributeName: Solarized.Base01,
            NSFontAttributeName: UIFont(name: "Menlo", size: 10.0)!]
        
        let numberString = "\(paragraphNumber)" as NSString
        let height = numberString.boundingRectWithSize(CGSize(width: 1000, height: 1000), options: [], attributes: numberStringAttributes, context: nil).size.height
        
        // Rect for number to be drawn into
        var numberRect = CGRect()
        numberRect.size.width = lineRect.width
        numberRect.origin.x = origin.x + 4
        numberRect.size.height = lineRect.height
        numberRect.origin.y = CGRectGetMidY(lineRect) - height*0.5 + origin.y
        
        // Draw paragraph number
        numberString.drawWithRect(numberRect, options: [.UsesLineFragmentOrigin], attributes: numberStringAttributes, context: nil)
    }
}
