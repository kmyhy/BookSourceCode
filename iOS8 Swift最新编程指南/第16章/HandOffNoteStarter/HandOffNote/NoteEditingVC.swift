//
//  NoteEditingVC.swift
//  HandOffNote
//
//  Created by yanghongyan on 15/1/23.
//  Copyright (c) 2015年 yanghongyan. All rights reserved.
//

import UIKit

protocol NoteEditingDelegate {
    func didEditNote(note:Note)->Void
}
class NoteEditingVC: UITableViewController,UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    
    var note:Note!
    var delegate:NoteEditingDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        if note != nil {
            title = note.createTimeString
            textView.text =  note.content
        }
        textView.delegate = self
    }

    @IBAction func completeAction(sender: AnyObject) {
        note.content = textView.text
        delegate?.didEditNote(note)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    // MARK: - TextViewDelegate
    func textViewDidBeginEditing(textView: UITextView){
    }
    func textViewDidChange(textView: UITextView){
        
    }
}
