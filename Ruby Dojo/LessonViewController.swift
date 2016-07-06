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
        textView.font = Solarized.Font
        textView.layer.borderColor = UIColor.redColor().CGColor
        textView.layer.borderWidth = 1.0
        textView.layoutManager.delegate = self
        textView.backgroundColor = Solarized.BackgroundColor
        
        // Substitute TextBoxViews
        while textView.text.containsString("TEXTBOX") {
            substituteTextbox()
            removePlaceHolder("TEXTBOX")
        }
        
        // Substitute TapBoxViews
        while textView.text.containsString("TAPBOX") {
            substituteTapBox()
            removePlaceHolder("TAPBOX")
        }
        
        // Set exclusion paths
        drawExclusionPaths()
        
        // Make main textview uneditable and selectable
        textView.selectable = false
        textView.editable = false
        
        // MARK: UIMenuController
        prepareMenuController()
        
        // MARK: Add tap gesture recognizer for dismissing keyboard
        dismissRespondersOnTapOut()
    }
    
  
    
    func prepareMenuController() {
        let menuController = UIMenuController.sharedMenuController()
        //menuController.menuVisible = true
        //menuController.setTargetRect(CGRectZero, inView: self.view)
        
        let menuItem1 = UIMenuItem(title: "223135", action: #selector(LessonViewController.onMenu1(_:)))
        let menuItem2 = UIMenuItem(title: "24.0", action: #selector(LessonViewController.onMenu2(_:)))
        
        menuController.menuItems = [menuItem1, menuItem2]
    }
    
    // MARK: Exclusion Paths
    func drawExclusionPaths() {
        
        // Reset exclusion paths
        textView.textContainer.exclusionPaths = []
        
        // Create empty array to hold exclusion paths
        var exclusionPaths = [UIBezierPath]()
        
        // TODO: Iterate over subviews using filter closure instead of if statement
        for subView in textView.subviews {
            if subView.dynamicType == Ruby_Dojo.TextBoxView || subView.dynamicType == Ruby_Dojo.TapBoxView {
                let convertedFrame = textView.convertRect(subView.frame, fromView: textView)
                
                // TODO: Make exclusion paths smaller to fix text closer to it.
                // TODO: Make a calculated value to subtract instead of magic numbers?
                let widthRightOffset: CGFloat = subView.dynamicType == Ruby_Dojo.TapBoxView ? 8 : 14
                let condensedFrame = CGRect(x: convertedFrame.origin.x + 10, y: convertedFrame.origin.y, width: convertedFrame.width - widthRightOffset , height: convertedFrame.height - 13.0)
                let path = UIBezierPath(rect: condensedFrame)
                exclusionPaths.append(path)
            }
        }
        
        // Set exclusion paths
        textView.textContainer.exclusionPaths = exclusionPaths
    }
    
    // MARK: Test method for recognizing taps
    func didRecognizeTap() {
        print("tapped!")
    }
    
    // MARK: Menu Actions
    func onMenu1(sender: UIMenuItem) {
        // TODO: Need to update the tapped textbox's text value here...
        activeTextField?.text = "223135"
        resizeTextField(activeTextField!)
        drawExclusionPaths()
        activeTextField?.resignFirstResponder()
    }
    func onMenu2(sender: UIMenuItem) {
        activeTextField?.text = "24.0"
        resizeTextField(activeTextField!)
        drawExclusionPaths()
        activeTextField?.resignFirstResponder()
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
        
        let finalFrame = CGRect(x: textView.frame.origin.x + resultFrame.origin.x + 8, y: textView.frame.origin.y + resultFrame.origin.y, width: width, height: 17.5)

        let textField = TapBoxView(frame: finalFrame)
        textField.addLeftPadding(2.0)
        textView.addSubview(textField)
        textField.delegate = self
        textField.placeholder = "Tap me!"
    }
    
    // MARK: Text Box
    func substituteTextbox() {
        let textboxRange = textView.text.rangeOfString("TEXTBOX")!
        
        let offset1 = textView.text.startIndex.distanceTo(textboxRange.startIndex)
        let offset2 = textView.text.startIndex.distanceTo(textboxRange.endIndex)
        
        let pos2: UITextPosition = textView.positionFromPosition(textView.beginningOfDocument, offset: offset2)!
        let pos1: UITextPosition = textView.positionFromPosition(textView.beginningOfDocument, offset: offset1)!
        
        let range: UITextRange = textView.textRangeFromPosition(pos1, toPosition: pos2)!
        
        let resultFrame: CGRect = textView.firstRectForRange(range)
        let screenWidth = UIScreen.mainScreen().bounds.width
        var rightOffset = CGFloat()
        
        // TODO: Textbox fills screen fine on 6+, not on 6 or 5s
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
        
        let finalFrame = CGRect(x: resultFrame.origin.x + 8, y: resultFrame.origin.y + 1.5, width: width, height: 17.5)
        
        let textField = TextBoxView(frame: finalFrame)
        textField.addLeftPadding(4.0)
        textView.addSubview(textField)
    }
    
    func countRows() -> CGFloat {
        return round( (textView.contentSize.height - textView.textContainerInset.top - textView.textContainerInset.bottom) / (textView.font!.lineHeight))
    }
    
    // MARK: Remove TEXTBOX/TAPBOX placeholder
    func removePlaceHolder(placeholder: String) {
        let truncated = textView.text.stringByReplacingFirstOccurrenceOfString(placeholder, withString: " ")
        textView.text = truncated
    }
    
    // MARK: Resize Instruction View's height based on content size
    func heightForTextView(textView: UITextView) -> CGFloat {
        let fixedWidth = textView.frame.size.width
        let sizeThatFitsContent = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        return sizeThatFitsContent.height
        
    }
    
    // MARK: Text Field Resizing to Content for Tapboxes
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
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
        dispatch_async(dispatch_get_main_queue()) {
            let menuController = UIMenuController.sharedMenuController()
            let frame = CGRect(x: 0, y: 0, width: textField.frame.width, height: 1)
            menuController.setTargetRect(frame, inView: textField)
            menuController.arrowDirection = UIMenuControllerArrowDirection.Down
            menuController.setMenuVisible(true, animated: true)
        }
    }
    
    // MARK: Create Textview: Main 'Text Editor'
    func createTextView() {
        // 1. Create the text storage that backs the editor
        // let attrs = [NSFontAttributeName : UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        let attrs = [NSFontAttributeName : Solarized.Font]
        let attrString = NSAttributedString(string: "@name = \"TEXTBOX \"\n@theOtherName = \"TEXTBOX \"\n@myValue = TAPBOX + 22.0", attributes: attrs)
        textStorage = SyntaxHighlightingTextStorage()
        textStorage.appendAttributedString(attrString)
        
        let newTextViewRect = view.bounds
        
        // 2. Create the layout manager
//        let layoutManager = NSLayoutManager()
        let layoutManager = SyntaxLayoutManager()
        
        // 3. Create a text container
        let containerSize = CGSize(width: newTextViewRect.width, height: CGFloat.max)
//        let container = NSTextContainer(size: containerSize)
        let container = SyntaxTextContainer(size: containerSize)
        container.widthTracksTextView = true
        
        layoutManager.addTextContainer(container)
        textStorage.addLayoutManager(layoutManager)
        
        // 4. Create a UITextView
        textView = UITextView(frame: newTextViewRect, textContainer: container)
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        // 5. Disable user interaction
        
        view.addSubview(textView)
        
        // 6. Add Constraints
        
        let topConstraint = NSLayoutConstraint(item: textView, attribute: .Top, relatedBy: .Equal, toItem: instructionsTextView, attribute: .Bottom, multiplier: 1, constant: 0)
        view.addConstraint(topConstraint)
        
        let bottomConstraint = NSLayoutConstraint(item: textView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint)
        
        let widthConstraint = NSLayoutConstraint(item: textView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        view.addConstraint(widthConstraint)
        
        
    }


}

