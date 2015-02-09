//
//  KeyboardViewController.swift
//  keyboard
//
//  Created by yanghongyan on 14/12/30.
//  Copyright (c) 2014年 yanghongyan. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    @IBOutlet weak var row1: UIView!
    @IBOutlet weak var row2: UIView!
    @IBOutlet weak var row3: UIView!
    @IBOutlet weak var row4: UIView!
    @IBOutlet weak var row5: UIView!
    @IBOutlet weak var altRow1: UIView!
    @IBOutlet weak var altRow2: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var punctuationButton: UIButton!
    @IBOutlet var nextKeyboardButton: UIButton!
    var isCapital:Bool = true
    func toggleCapital(views:[UIView]){
        for v in views{
            for subview in v.subviews{
                if let button = subview as? UIButton {
                    if let btnTitle = button.titleLabel!.text {
                        if btnTitle.isMatch("^[a-z]$") && isCapital == true {
                            button.setTitle(btnTitle.uppercaseString, forState: .Normal)
                        }
                        if btnTitle.isMatch("^[A-Z]$") && isCapital == false {
                            button.setTitle(btnTitle.lowercaseString, forState: .Normal)
                        }
                    }
                }
            }
        }
    }
    func togglePunctuation(button:UIButton){
        let btnTitle = button.titleLabel!.text
        row1.hidden = true
        altRow1.hidden = true
        altRow2.hidden = true
        
        switch btnTitle!{
        case "符号<?":
            altRow1.hidden = false
            button.setTitle("数字", forState: .Normal)
        case "数字":
            altRow2.hidden = false
            button.setTitle("符号!@", forState: .Normal)
        case "符号!@":
            row1.hidden = false
            button.setTitle("符号<?", forState: .Normal)
        default:
            break
        }
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }
    @IBAction func keyPressed(button: UIButton) {
        var btnTitle = button.titleLabel!.text
        let input = textDocumentProxy as UIKeyInput
        switch btnTitle! {
        case "大写":
            isCapital = true
            button.setTitle("小写", forState: .Normal)
            toggleCapital([row2,row3,row4])
        case "小写":
            isCapital = false
            button.setTitle("大写", forState: .Normal)
            toggleCapital([row2,row3,row4])
        case "\u{0000232B}":// 删除
            input.deleteBackward()
        case "\u{0001F310}":// 键盘切换
            advanceToNextInputMode()
        case "回车":
            input.insertText("\n")
        case "空格":
            input.insertText(" ")
        case "符号<?","数字","符号!@":
            togglePunctuation(button);
        default:
            input.insertText("\(btnTitle!)")
        }
        UIView.animateWithDuration(0.2, animations: {
            button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3)
            }, completion: {(_) -> Void in
                button.transform =
                CGAffineTransformScale(CGAffineTransformIdentity, 1, 1)
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "KeyboardView", bundle: nil)
        let objects = nib!.instantiateWithOwner(self, options: nil)
        view = objects[0] as UIView;
        
        deleteButton.setTitle("\u{0000232B}", forState: .Normal)
        nextKeyboardButton.setTitle("\u{0001F310}", forState: .Normal)
        
        addKeysTarget()
        togglePunctuation(punctuationButton)
    }

    func addKeysTarget(){
        for row in view.subviews {
            for subview in row.subviews{
                if let button = subview as? UIButton {
                    button.addTarget(self, action: "keyPressed:", forControlEvents: UIControlEvents.TouchUpInside)
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textWillChange(textInput: UITextInput) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput) {
        // The app has just changed the document's contents, the document context has been updated.
    
        var textColor: UIColor
        var proxy = self.textDocumentProxy as UITextDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
            textColor = UIColor.whiteColor()
        } else {
            textColor = UIColor.blackColor()
        }
        self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
    }

}
