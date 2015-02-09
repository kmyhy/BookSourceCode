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
    override func viewWillDisappear(animated: Bool) {
        userActivity?.invalidate()
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
        let activity = NSUserActivity(activityType: ActivityTypeEdit)
        activity.title = "编辑备忘录"
        let item = (countElements(textView.text) > 0) ? textView.text : ""
        note.content = item
        activity.userInfo = ["item": note]
        userActivity = activity
        userActivity?.becomeCurrent()
    }
    func textViewDidChange(textView: UITextView){
        note.content = textView.text
        userActivity?.needsSave = true
    }
    // MARK: Handoff
    override func updateUserActivityState(activity: NSUserActivity) {
        let item = (countElements(textView.text) > 0) ? textView!.text : ""
        note.content = item
        activity.addUserInfoEntriesFromDictionary(["item": note])
        super.updateUserActivityState(activity)
    }
    override func restoreUserActivityState(activity: NSUserActivity) {
        if let userInfo = activity.userInfo {
            var item: AnyObject? = userInfo["item"]
            if let itemToRestore = item as? Note {
                note = itemToRestore
                textView?.text = note.content
            }
        }
        super.restoreUserActivityState(activity)
    }
}
