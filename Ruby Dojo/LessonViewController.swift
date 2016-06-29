//
//  LessonViewController.swift
//  Ruby Dojo
//
//  Created by Patrick Montalto on 6/6/16.
//  Copyright © 2016 swift. All rights reserved.
//

import UIKit

class LessonViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, NSLayoutManagerDelegate {
    @IBOutlet var instructionsTextView: UITextView!

    @IBOutlet var instructionsHeightConstraint: NSLayoutConstraint!
    var textView: UITextView!
    var textStorage: NSTextStorage!
    
    var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instructionsTextView.userInteractionEnabled = false
        instructionsTextView.text = "Hello! Welcome to the Ruby Dojo! \nThis is the first lesson."
        instructionsHeightConstraint.constant = heightForTextView(instructionsTextView)
        
        instructionsTextView.layer.borderColor = UIColor.greenColor().CGColor
        instructionsTextView.layer.borderWidth = 1.0
        
        createTextView()
        textView.font = UIFont(name: "Menlo", size: 13.0)
        textView.layer.borderColor = UIColor.redColor().CGColor
        textView.layer.borderWidth = 1.0
        textView.editable = false
        textView.layoutManager.delegate = self
        textView.backgroundColor = Solarized.BackgroundColor
        
        // TODO: Make textbox stretch to fill until margin, leaving just enough space for one quotation mark
        /* 
         Need to add quotation mark after box.
         The trick will be to keep adding blank characters after the 'TEXTBOX' until the cursor is two keys away from
         returning to a new line, then a quotation mark is inserted (for now, a single quote)
         */
        print("The textView's origin x is: \(textView.frame.origin.x)")
        print("The textField's origin x is: \(textView.frame.width)")
    
        while textView.text.containsString("TEXTBOX") {
            substituteTextbox()
            removePlaceHolder("TEXTBOX")
        }
        
        while textView.text.containsString("TAPBOX") {
            substituteTapBox()
            removePlaceHolder("TAPBOX")
        }
        //addTrailingQuotation(withCurrentRowCount: rowCount)
        
        // MARK: UIMenuController
        // Make controller
        let menuController = UIMenuController.sharedMenuController()
        //menuController.menuVisible = true
        //menuController.arrowDirection = UIMenuControllerArrowDirection.Down
        //menuController.setTargetRect(CGRectZero, inView: self.view)
        
        let menuItem1 = UIMenuItem(title: "Harry the Nematoad", action: #selector(LessonViewController.onMenu1(_:)))
        let menuItem2 = UIMenuItem(title: "+", action: #selector(LessonViewController.onMenu2(_:)))
        menuController.menuItems = [menuItem1, menuItem2]
        
    }
    
    func didRecognizeTap() {
        print("tapped!")
    }
    
    internal func onMenu1(sender: UIMenuItem) {
        // TODO: Need to update the tapped textbox's text value here...
        activeTextField?.text = "Harry The Nematoad"
        resizeTextField(activeTextField!)
    }
    internal func onMenu2(sender: UIMenuItem) {
        activeTextField?.text = "+"
        resizeTextField(activeTextField!)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: Tap Box
    func substituteTapBox() {
        let tapboxRange = textView.text.rangeOfString("TAPBOX")!
        
        let offset1 = textView.text.startIndex.distanceTo(tapboxRange.startIndex)
        let offset2 = textView.text.startIndex.distanceTo(tapboxRange.endIndex)
        
        let pos1: UITextPosition = textView.positionFromPosition(textView.beginningOfDocument, offset: offset1)!
        let pos2: UITextPosition = textView.positionFromPosition(textView.beginningOfDocument, offset: offset2)!
        
        let range: UITextRange = textView.textRangeFromPosition(pos1, toPosition: pos2)!
        
        let resultFrame: CGRect = textView.firstRectForRange(range)
        
        let width: CGFloat = 60
        
        let finalFrame = CGRect(x: resultFrame.origin.x, y: resultFrame.origin.y, width: width, height: 17.5)

        let textField = TapBoxView(frame: finalFrame)
        textField.addLeftPadding(2.0)
        textView.addSubview(textField)
        textField.delegate = self
        textField.placeholder = "Tap me!"
        // TODO: expand/shrink text after tapBox to adjust to right of growing/shrinking tapBox
        // MARK: Add tap gesture recognizer
        let aSelector: Selector = #selector(LessonViewController.didRecognizeTap)
        let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
        textView.superview?.addGestureRecognizer(tapGesture)

    }
    
    // MARK: Text Box
    func substituteTextbox() {
        let textboxRange = textView.text.rangeOfString("TEXTBOX")!
        
        let offset1 = textView.text.startIndex.distanceTo(textboxRange.startIndex)
        let offset2 = textView.text.startIndex.distanceTo(textboxRange.endIndex)
        
        let pos2: UITextPosition = textView.positionFromPosition(textView.beginningOfDocument, offset: offset2)!
        let pos1: UITextPosition = textView.positionFromPosition(textView.beginningOfDocument, offset: offset1)!
        //print("pos1: \(pos1), pos2: \(pos2)")
        let range: UITextRange = textView.textRangeFromPosition(pos1, toPosition: pos2)!
        
        let resultFrame: CGRect = textView.firstRectForRange(range)
        let screenWidth = UIScreen.mainScreen().bounds.width
        var rightOffset = CGFloat()
        switch (screenWidth) {
        case 320.0:
            rightOffset = -100
        case 375.0:
            rightOffset = -46
        case 414:
            rightOffset = -16
        default:
            rightOffset = 0
        }
        let width = textView.frame.width - resultFrame.origin.x + rightOffset
        
        let finalFrame = CGRect(x: resultFrame.origin.x, y: resultFrame.origin.y + 1.5, width: width, height: 17.5)
        
        //print("x:\(resultFrame.origin.x), y:\(resultFrame.origin.y)")
        let textField = TextBoxView(frame: finalFrame)
        textField.addLeftPadding(4.0)
        textView.addSubview(textField)

    }
    
    func countRows() -> CGFloat {
        return round( (textView.contentSize.height - textView.textContainerInset.top - textView.textContainerInset.bottom) / (textView.font!.lineHeight))
    }
    
    // TODO: Remove TEXTBOX placeholder
    func removePlaceHolder(placeholder: String) {
        let truncated = textView.text.stringByReplacingFirstOccurrenceOfString(placeholder, withString: " ")
        textView.text = truncated
    }
    
    // Need the ability to add a trailing quotation for any given box on any line, not just the last line!
    
    func addTrailingQuotation(withCurrentRowCount initialRowCount: CGFloat) {
        // make row count a variable, keep calculating at the end of each loop.
        var currentRowCount = countRows()
        while currentRowCount <= initialRowCount {
            // Keep adding blank characters until we increase the number of rows in the textView
            textView.text = textView.text.stringByAppendingString("_")
            print("adding character...")
            currentRowCount = countRows()
        }
        print(countRows())
        
        if countRows() > initialRowCount {
            // Remove last two characters, the one on the new line and the last blank on the prior line
            var truncated = textView.text
            truncated.removeAtIndex(truncated.endIndex.predecessor())
            truncated.removeAtIndex(truncated.endIndex.predecessor())
            textView.text = truncated
            // Append closing quotation mark
            textView.text = textView.text.stringByAppendingString("'")
            
        }
    }
    
    func heightForTextView(textView: UITextView) -> CGFloat {
        let fixedWidth = textView.frame.size.width
        let sizeThatFitsContent = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        return sizeThatFitsContent.height
        
    }
    
    // MARK: Text Field Resizing to Content
    func resizeTextField(textField: UITextField) {
        textField.placeholder = ""
        textField.sizeToFit()
        textField.placeholder = "Tap me!"
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    // MARK: Line Height
    func layoutManager(layoutManager: NSLayoutManager, lineSpacingAfterGlyphAtIndex glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return 4.0
    }
    
    // MARK: Set active textfield when tapped
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        activeTextField = textField
        return true
    }
    
    // MARK: Create Textview
    func createTextView() {
        // 1. Create the text storage that backs the editor
        // let attrs = [NSFontAttributeName : UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        let attrs = [NSFontAttributeName : UIFont(name: "Menlo", size: 12.0)!]
        let attrString = NSAttributedString(string: "1|@name = \"TEXTBOX\n2|@theOtherName = \"TEXTBOX\nTAPBOX = 22.0", attributes: attrs)
        textStorage = SyntaxHighlightingTextStorage()
        textStorage.appendAttributedString(attrString)
        
        let newTextViewRect = view.bounds
        
        // 2. Create the layout manager
        let layoutManager = NSLayoutManager()
        
        // 3. Create a text container
        let containerSize = CGSize(width: newTextViewRect.width, height: CGFloat.max)
        let container = NSTextContainer(size: containerSize)
        container.widthTracksTextView = true
        layoutManager.addTextContainer(container)
        textStorage.addLayoutManager(layoutManager)
        
        // 4. Create a UITextView
        textView = UITextView(frame: newTextViewRect, textContainer: container)
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(textView)
        
        // 5. Add Constraints
        
        let topConstraint = NSLayoutConstraint(item: textView, attribute: .Top, relatedBy: .Equal, toItem: instructionsTextView, attribute: .Bottom, multiplier: 1, constant: 0)
        view.addConstraint(topConstraint)
        
        let bottomConstraint = NSLayoutConstraint(item: textView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint)
        
        let widthConstraint = NSLayoutConstraint(item: textView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        view.addConstraint(widthConstraint)
        
        
    }


}

