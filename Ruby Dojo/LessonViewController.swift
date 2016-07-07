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
    
    var activeTextField: UITextField?
    var menuItemActions: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: Set up instructions text view
        instructionsTextView.userInteractionEnabled = false
        instructionsTextView.text = "Hello! Welcome to the Ruby Dojo! \nThis is the first lesson."
        instructionsHeightConstraint.constant = heightForTextView(instructionsTextView)
        
        instructionsTextView.layer.borderColor = UIColor.greenColor().CGColor
        instructionsTextView.layer.borderWidth = 1.0
        
        // MARK: Set up main text view
        textView = SyntaxTextViewCreator.createWithText("@name = \"TEXTBOX \"\n@theOtherName = \"TEXTBOX \"\n@myValue = TAPBOX + 22.0\nputs @name \nclass Test \nmy_value = true \ndef\n\t5 + 5\nend", view: self.view)
        
        // Set delegate and add to View
        
        view.addSubview(textView)
        textView.delegate = self
        
        // Add Constraints
        
        let topConstraint = NSLayoutConstraint(item: textView, attribute: .Top, relatedBy: .Equal, toItem: instructionsTextView, attribute: .Bottom, multiplier: 1, constant: 0)
        view.addConstraint(topConstraint)
        
        let bottomConstraint = NSLayoutConstraint(item: textView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint)
        
        let widthConstraint = NSLayoutConstraint(item: textView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        view.addConstraint(widthConstraint)

        
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
        
        // MARK: Get menu item actions
        menuItemActions = ["223135", "24.0", "name"]
        
        // MARK: UIMenuController
        prepareMenuController()
        
        // MARK: Add tap gesture recognizer for dismissing keyboard
        dismissRespondersOnTapOut()
    }
    
  
    
    func prepareMenuController() {
        /* GUARD: Are there any menu item actions? */
        guard let menuItemActions = menuItemActions else {
            return
        }
        
        let menuController = UIMenuController.sharedMenuController()
        menuController.menuItems = []
        
        for (index, menuItemAction) in menuItemActions.enumerate() {
            menuController.menuItems?.append(UIMenuItem(title: menuItemAction, action: NSSelectorFromString("onMenu\(index):")))
        }
    }
    
    // MARK: Exclusion Paths
    func drawExclusionPaths() {
        
        // Reset exclusion paths
        textView.textContainer.exclusionPaths = []
        
        // Create empty array to hold exclusion paths
        var exclusionPaths = [UIBezierPath]()
        
        // Iterate over subviews using filter closure instead of if statement
        let subViews = textView.subviews.filter { $0 is TextBoxView || $0 is TapBoxView }
        for subView in subViews {
            let convertedFrame = textView.convertRect(subView.frame, fromView: textView)
            
            let widthRightOffset: CGFloat = subView.dynamicType == Ruby_Dojo.TapBoxView ? 8 : 14
            let condensedFrame = CGRect(x: convertedFrame.origin.x + 10, y: convertedFrame.origin.y, width: convertedFrame.width - widthRightOffset , height: convertedFrame.height - 13.0)
            let path = UIBezierPath(rect: condensedFrame)
            exclusionPaths.append(path)
            
        }
        
        // Set exclusion paths
        textView.textContainer.exclusionPaths = exclusionPaths
    }
    
    // MARK: - Menu Actions
    func onMenu0(sender: UIMenuController) {
        /* GUARD: Check menuItemActions */
        guard let menuItemActions = menuItemActions else {
            return
        }
        
        activeTextField?.text = menuItemActions[1]
        resizeViewsAfterItemSelection()
    }
    func onMenu1(sender: UIMenuController) {
        /* GUARD: Check menuItemActions */
        guard let menuItemActions = menuItemActions else {
            return
        }
        guard menuItemActions.count >= 2 else {
            return
        }
        
        activeTextField?.text = menuItemActions[1]
        resizeViewsAfterItemSelection()
    }
    func onMenu2(sender: UIMenuController) {
        /* GUARD: Check menuItemActions */
        guard let menuItemActions = menuItemActions else {
            return
        }
        
        guard menuItemActions.count >= 3 else {
            return
        }
        
        activeTextField?.text = menuItemActions[2]
        resizeViewsAfterItemSelection()
    }
    
    func resizeViewsAfterItemSelection() {
        resizeTextField(activeTextField!)
        drawExclusionPaths()
        activeTextField?.resignFirstResponder()
    }
    
    // MARK: Resize Instruction View's height based on content size
    func heightForTextView(textView: UITextView) -> CGFloat {
        let fixedWidth = textView.frame.size.width
        let sizeThatFitsContent = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        return sizeThatFitsContent.height
        
    }
    // MARK: - Tapbox and Textbox
    
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
        
        let finalFrame = CGRect(x: textView.frame.origin.x + resultFrame.origin.x, y: textView.frame.origin.y + resultFrame.origin.y, width: width, height: 14.5)

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
        let rightOffset: CGFloat = -32
        
       
        let width = textView.frame.width - resultFrame.origin.x + rightOffset
        
        let finalFrame = CGRect(x: resultFrame.origin.x, y: resultFrame.origin.y + 1.5, width: width, height: 14.5)
        
        let textField = TextBoxView(frame: finalFrame)
        textField.addLeftPadding(4.0)
        textView.addSubview(textField)
        
        // Set Delegate
        textField.delegate = self
    }
    
    // MARK: Remove TEXTBOX/TAPBOX placeholder
    func removePlaceHolder(placeholder: String) {
        let truncated = textView.text.stringByReplacingFirstOccurrenceOfString(placeholder, withString: " ")
        textView.text = truncated
    }
    
    // MARK: Text Field Resizing to Content for Tapboxes
    func resizeTextField(textField: UITextField) {
        textField.placeholder = ""
        textField.sizeToFit()
        textField.placeholder = "Tap me!"
    }
    // MARK: - TextField Delegate Methods
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return textField.dynamicType == Ruby_Dojo.TextBoxView
    }
    
    // Line Height
    func layoutManager(layoutManager: NSLayoutManager, lineSpacingAfterGlyphAtIndex glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return 1.0
    }
    
    // Set active textfield when tapped
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField.dynamicType == Ruby_Dojo.TapBoxView {
            activeTextField = textField
            
            dispatch_async(dispatch_get_main_queue()) {
                textField.resignFirstResponder()
                let menuController = UIMenuController.sharedMenuController()
                let frame = CGRect(x: 0, y: 0, width: textField.frame.width, height: 1)
                menuController.setTargetRect(frame, inView: textField)
                menuController.arrowDirection = UIMenuControllerArrowDirection.Down
                menuController.setMenuVisible(true, animated: true)
            }
        }
        return true
    }
    
    // Dismiss keyboard on enter
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

