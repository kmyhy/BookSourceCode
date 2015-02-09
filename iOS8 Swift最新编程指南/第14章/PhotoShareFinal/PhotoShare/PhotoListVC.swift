//
//  PhotoListVC.swift
//  PhotoShare
//
//  Created by yanghongyan on 15/1/7.
//  Copyright (c) 2015年 yanghongyan. All rights reserved.
//

import UIKit
import CloudKit

class PhotoListVC: UITableViewController {

    var items:[CKPhoto] = []
    var resultBeginArrived:Bool = false
    var inProgress:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        if !inProgress {
            inProgress = true
            let query = CKQuery(recordType: "Photo", predicate: NSPredicate(value: true))
            let queryOp = CKQueryOperation(query: query)
            queryOp.desiredKeys = ["poster","description","createdAt"]
            sendOperation(queryOp)
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

  
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return items.count
    }
    func sendOperation(queryOp:CKQueryOperation) {

        queryOp.queryCompletionBlock = {
            cursor,error in
            // Check Error's type to retry request
            // 1
            if isRetryableCKError(error) {
                let userInfo : NSDictionary = error.userInfo!
                // 2
                if let retryAfter = userInfo[CKErrorRetryAfterKey] as? NSNumber {
                let delay = retryAfter.doubleValue * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                // 3
                dispatch_after(time, dispatch_get_main_queue()) {
                    let query = CKQuery(recordType: "Photo", predicate: NSPredicate(value: true))
                    let queryOp = CKQueryOperation(query: query)
                    queryOp.desiredKeys = ["poster","description","createdAt"]
                    self.sendOperation(queryOp)
                }
                return
                }
            }
            
            self.resultBeginArrived = false
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.endUpdates()
            })
            if cursor != nil {
                let op = CKQueryOperation(cursor: cursor)
                self.sendOperation(op)
            }else{
                self.inProgress = false
            }
        }
        queryOp.recordFetchedBlock = {
            record in
            if !self.resultBeginArrived {
                self.resultBeginArrived = true
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.beginUpdates()
                })
            }
            var index = NSNotFound
            var foto: CKPhoto!
            var newItem = true
            for (idx,value) in enumerate(self.items) {
                if value.id == record.recordID.recordName {
                    index = idx
                    foto = value
                    foto.record = record
                    newItem = false
                    break
                }
            }
            if index == NSNotFound {
                foto = CKPhoto(record: record)
                self.items.append(foto)
                index = self.items.count - 1
            }
            dispatch_sync(dispatch_get_main_queue()
                , { () -> Void in
                    let indexPath = NSIndexPath(forRow: index, inSection: 0)
                    if newItem {
                        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    }else{
                        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    }
            })
        }
        queryOp.resultsLimit = 20
        resultBeginArrived = false
        publicDB.addOperation(queryOp)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idCell", forIndexPath: indexPath) as PhotoListCell
        
        let foto = items[indexPath.row]

        cell.configureCell(foto)

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
