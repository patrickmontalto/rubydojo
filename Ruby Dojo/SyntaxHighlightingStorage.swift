//
//  SyntaxHighlightingTextStorage.swift
//  SwiftTextKitNotepad
//
//  Created by Patrick Montalto on 6/26/16.
//  Copyright © 2016 Gabriel Hauber. All rights reserved.
//

import UIKit

class SyntaxHighlightingTextStorage: NSTextStorage {
    
    // Initializers
    override init() {
        super.init()
        createHighlightPatterns()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    // A text storage subclass must provide its own persistence
    let backingStore = NSMutableAttributedString()
    
    // Override the string computed property, deferring to the backing store
    override var string: String {
        return backingStore.string
    }
    
    // Delegate to the backingStore
    override func attributesAtIndex(location: Int, effectiveRange range: NSRangePointer) -> [String : AnyObject] {
        return backingStore.attributesAtIndex(location, effectiveRange: range)
    }
    
    // Mandatory Overrides
    
    override func replaceCharactersInRange(range: NSRange, withString str: String) {
        print("replaceCharactersInRange:\(range) withString:\(str)")
        
        beginEditing()
        backingStore.replaceCharactersInRange(range, withString:str)
        edited([.EditedCharacters,.EditedAttributes], range: range, changeInLength: (str as NSString).length - range.length)
        endEditing()
    }
    
    override func setAttributes(attrs: [String : AnyObject]?, range: NSRange) {
        beginEditing()
        backingStore.setAttributes(attrs, range: range)
        edited(.EditedAttributes, range: range, changeInLength: 0)
        endEditing()
    }
    func applyStylesToRange(searchRange: NSRange) {
        let normalAttrs = [NSForegroundColorAttributeName : UIColor.blackColor(), NSFontAttributeName : UIFont(name: "Menlo", size: 13.0)!]
        var regex = NSRegularExpression()
        // iterate over each replacement
        for (pattern, attributes) in replacements {
            do {
                regex = try NSRegularExpression(pattern: pattern, options: [])
            } catch {}
            regex.enumerateMatchesInString(backingStore.string, options: [], range: searchRange) {
                match, flags, stop in
                // apply the style
                let matchRange = match!.rangeAtIndex(1)
                print(matchRange)
                self.addAttributes(attributes as! [String:AnyObject], range: matchRange)
                
                // reset the style to the original
                let maxRange = matchRange.location + matchRange.length
                if maxRange + 1 < self.length {
                    self.addAttributes(normalAttrs, range: NSMakeRange(maxRange, 1))
                }
            }
        }
    }
    
    func performReplacementsForRange(changedRange: NSRange) {
        var extendedRange = NSUnionRange(changedRange, NSString(string: backingStore.string).lineRangeForRange(NSMakeRange(changedRange.location, 0)))
        extendedRange = NSUnionRange(changedRange, NSString(string: backingStore.string).lineRangeForRange(NSMakeRange(NSMaxRange(changedRange), 0)))
        applyStylesToRange(extendedRange)
    }
    
    override func processEditing() {
        performReplacementsForRange(self.editedRange)
        super.processEditing()
    }
    
    // Adding further styles
    func createAttributesForFontStyle(style: String, withTrait trait: UIFontDescriptorSymbolicTraits) -> [NSObject : AnyObject] {
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptorWithTextStyle(UIFontTextStyleBody)
        let descriptorWithTrait = fontDescriptor.fontDescriptorWithSymbolicTraits(trait)
        let font = UIFont(descriptor: descriptorWithTrait, size: 0)
        return [NSFontAttributeName : font]
    }
    var replacements: [String : [NSObject : AnyObject]]!
    
    func createHighlightPatterns() {
        let boldAttributes = createAttributesForFontStyle(UIFontTextStyleBody, withTrait:.TraitBold)
        let italicAttributes = createAttributesForFontStyle(UIFontTextStyleBody, withTrait:.TraitItalic)
        let strikeThroughAttributes = [NSStrikethroughStyleAttributeName : 1]
        let blueTextAttributes = [NSForegroundColorAttributeName : Solarized.BlueColor]
        let grayTextAttributes: [String:AnyObject] = [
            NSForegroundColorAttributeName: UIColor.grayColor(),
            NSFontAttributeName: UIFont(name: "Menlo", size: 10.0)!]
//        let smallTextAttributes = [NSFontAttributeName: UIFont(name: "Menlo", size: 12.0)]
        // construct a dictionary of replacements based on regexes
        replacements = [
            "(\\*\\w+(\\s\\w+)*\\*)" : boldAttributes,
            "(_\\w+(\\s\\w+)*_)" : italicAttributes,
            "([0-9]+\\|)" : grayTextAttributes,
            "(-\\w+(\\s\\w+)*-)" : strikeThroughAttributes,
            "(@name|@theOtherName)\\s" : blueTextAttributes
        ]
    }
    
}
