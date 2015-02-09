//
//  NoteListVC.swift
//  HandOffNote
//
//  Created by yanghongyan on 15/1/23.
//  Copyright (c) 2015年 yanghongyan. All rights reserved.
//

import UIKit

class NoteListVC: UITableViewController,NoteEditingDelegate{
    var items:[Note] = []
    var selectedItemIndexPath:NSIndexPath!
    
    func startActivity() {
        let activity = NSUserActivity(activityType: ActivityTypeView)
        activity.title = "查看备忘录"
        activity.userInfo = ["items": items]
        userActivity = activity
        userActivity?.becomeCurrent()
    }
    override func updateUserActivityState(activity: NSUserActivity) {
        activity.addUserInfoEntriesFromDictionary(["items": items])
        super.updateUserActivityState(activity)
    }
    override func restoreUserActivityState(activity: NSUserActivity) {
        if let userInfo = activity.userInfo {
            if let importedItems = userInfo["items"] as? NSArray {
                items.removeAll(keepCapacity: true)
                for item in importedItems {
                    items.append(item as Note)
            
                }
            }
            NoteManager.shareInstance().updateItems(items)
            NoteManager.shareInstance().commit()
            tableView.reloadData()
        }
        super.restoreUserActivityState(activity)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        NoteManager.shareInstance().fetchItems({ (items:[Note]) in
            self.items = items
            self.tableView.reloadData()
            if items.isEmpty == false {
                self.startActivity()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idCell", forIndexPath: indexPath) as UITableViewCell

        let note = items[indexPath.row]
        cell.textLabel?.text = note.createTimeString
        cell.detailTextLabel?.text = note.content

        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let note = items[indexPath.row]
        performSegueWithIdentifier("idEditNote", sender: note)
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // Update data source and UI.
        let index = indexPath.row
        let itemToRemove = items[index]
        items.removeAtIndex(index)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
        
        // Update persistent store.
        NoteManager.shareInstance().updateItems(items)
        NoteManager.shareInstance().commit()
        tableView.reloadData()
        
        if items.isEmpty {
            userActivity?.invalidate()
        } else {
            userActivity?.needsSave = true
        }
    }
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "idCreateNote" {
            let vc = segue.destinationViewController as NoteEditingVC
            let note = Note()
            note.createTime = NSDate()
            vc.note = note
            vc.delegate = self
        }else if segue.identifier == "idEditNote" {
            let vc = segue.destinationViewController as NoteEditingVC
            vc.note = sender as? Note
            vc.delegate = self
        }
        userActivity?.invalidate()
    }
    @IBAction func unwindToNotListVC(segue: UIStoryboardSegue) {
        if selectedItemIndexPath != nil {
            tableView.deselectRowAtIndexPath(selectedItemIndexPath, animated: true)
            selectedItemIndexPath = nil
        }
        
        startActivity()
    }
    

    func didEditNote(note: Note) {
        if let index = self.findItem(note) {
            self.items[index] = note
        }else{
            self.items.append(note)
        }
        NoteManager.shareInstance().updateItems(self.items)
        NoteManager.shareInstance().commit()
        tableView.reloadData()
        if !items.isEmpty {
            startActivity()
        }
    }
    private func findItem(note:Note)->Int?{
        for (index, item) in enumerate(items){
            if item.NoteID == note.NoteID {
                return index
            }
        }
        return nil
    }
}
