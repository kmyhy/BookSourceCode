//
//  CollectionListVC.swift
//  PhotoPickerStarter
//
//  Created by yanghongyan on 15/1/15.
//  Copyright (c) 2015年 yanghongyan. All rights reserved.
//

import UIKit
import Photos

protocol PhotoPickerDelegate {
    func didSelect(selectedAssets: [PHAsset])
    func didCancel()
}
class CollectionListVC: UITableViewController {

    var delegate: PhotoPickerDelegate?
    var selectedAssets: [PHAsset] = []
    
    private let sectionNames = ["","","相册"]
    private var userAlbums: PHFetchResult!
    private var userFavorites: PHFetchResult!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Actions
    @IBAction func donePressed(sender: AnyObject) {
        delegate?.didSelect(selectedAssets)
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        delegate?.didCancel()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }

}
