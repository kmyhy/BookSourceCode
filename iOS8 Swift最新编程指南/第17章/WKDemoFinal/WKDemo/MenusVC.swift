//
//  MenusVC.swift
//  WKDemo
//
//  Created by yanghongyan on 15/1/28.
//  Copyright (c) 2015年 yanghongyan. All rights reserved.
//

import UIKit

let menuItemSelected = "menuItemSelected"

class MenusVC: UITableViewController {
    var items: [Menu] = []
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idCell", forIndexPath: indexPath) as UITableViewCell
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = items[indexPath.row]
        NSNotificationCenter.defaultCenter().postNotificationName(menuItemSelected, object: item)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func close(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
