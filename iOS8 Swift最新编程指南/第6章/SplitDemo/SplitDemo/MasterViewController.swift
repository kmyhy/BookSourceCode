//
//  MasterViewController.swift
//  SplitDemo
//
//  Created by chen neng on 14-10-5.
//  Copyright (c) 2014年 kmyhy. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController,PaletteSelectionContainer {

    var detailViewController: DetailViewController? = nil
    var objects = dataSource()

    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.navigationItem.leftBarButtonItem = self.editButtonItem()
//
//        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
//        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! NavigationController).topViewController as? DetailViewController
        }
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "showDetailTargetChanged:",
            name: UIViewControllerShowDetailTargetDidChangeNotification, object: nil)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let detailNav = segue.destinationViewController as! UINavigationController
                let detailVC  = detailNav.topViewController as! DetailViewController
                let palette   = objects[indexPath.row] as ColorPalette
                detailVC.detailItem=palette
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        let colorPalette = objects[indexPath.row] as ColorPalette
        cell.textLabel?.text = colorPalette.name
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let palette=objects[indexPath.row]
        if palette.children != nil && palette.children.count > 0 {
            if palette.hasColors == false {
                let newTable = storyboard?.instantiateViewControllerWithIdentifier("MasterVC") as! MasterViewController
                newTable.objects = palette.children
                newTable.title = palette.name
//                navigationController?.pushViewController(newTable, animated: true)
                showViewController(newTable, sender: self)
            }
        }
    }
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath) {
        var segueWillPush = false
        let colorPalette = objects[indexPath.row] as ColorPalette
        if colorPalette.children == nil {
            segueWillPush = false
        }else if  colorPalette.hasColors == false {
            segueWillPush = showVCWillPush(self)
        } else {
            segueWillPush = showDetailVCWillPush(self)
        }
        cell.accessoryType = segueWillPush ?
        .DisclosureIndicator : .None
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "showDetail" {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let palette=objects[selectedIndexPath.row]
                return palette.hasColors
            }
            return false
        }
        return true
    }
    func selectedPalette() -> ColorPalette? {
        let selectedIndex = tableView.indexPathForSelectedRow
        if let indexPath = selectedIndex {
            let palette=objects[indexPath.row]
            if palette.hasColors==true {
                return palette
            }
        }
        return nil
    }
    deinit {
            NSNotificationCenter.defaultCenter().removeObserver(self,
            name: UIViewControllerShowDetailTargetDidChangeNotification,
            object: nil)
    }
    
    func showDetailTargetChanged(sender: AnyObject?) {
        if let indexPaths = tableView.indexPathsForVisibleRows {
            for indexPath in indexPaths as [NSIndexPath] {
                let cell = tableView.cellForRowAtIndexPath(indexPath)
                tableView(tableView, willDisplayCell: cell!,
                    forRowAtIndexPath: indexPath)
            }
        }
    }
}






