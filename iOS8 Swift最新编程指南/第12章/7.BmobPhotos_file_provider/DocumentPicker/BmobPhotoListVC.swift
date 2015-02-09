//
//  BmobPhotoListVC.swift
//  BmobPhotos
//
//  Created by yanghongyan on 14/12/21.
//  Copyright (c) 2014年 yanghongyan. All rights reserved.
//

import UIKit

@objc protocol BmobPhotoListDelegate{
    func didSelect(photo:BmobObject)
}
class BmobPhotoListVC: UITableViewController {
    weak var delegate:BmobPhotoListDelegate?
    var photos : [BmobObject] = []
    var documentPickerMode: UIDocumentPickerMode?
    override func viewDidLoad() {
        super.viewDidLoad()
        registerBmob()
        loadBmobObjects { (array) -> Void in
            self.photos = array
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idCell", forIndexPath: indexPath) as BmobPhotoListCell
        // 1
        let photo = photos[indexPath.row]
        let file = photo.objectForKey("file") as BmobFile
        // 2
        BmobImage.thumbnailImageBySpecifiesTheWidth(64, height: 64, quality: 70, sourceImageUrl: file.url, outputType: kBmobImageOutputBmobFile) { (obj, error) -> Void in
            // 3
            if let file = obj as? BmobFile {
                if let fileUrl = NSURL(string: file.url) {
                    cell.imageView?.setImageWithUrl(fileUrl, completionHandler: { (image) -> Void in
                        cell.setNeedsLayout()
                    })
                }
            }
        }
        // 4
        if documentPickerMode == .ExportToService{
            cell.label.text = "导出"
        }else if documentPickerMode == .Import {
            cell.label.text = "导入"
        }else if documentPickerMode == .MoveToService {
            cell.label.text = "移动"
        }else if documentPickerMode == .Open {
            cell.label.text = "打开"
        }else {
            cell.label.text = nil
        }
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let photo = photos[indexPath.row]
        delegate?.didSelect(photo)
    }
}
