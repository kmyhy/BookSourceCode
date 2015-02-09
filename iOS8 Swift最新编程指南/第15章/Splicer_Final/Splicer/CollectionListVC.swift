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
class CollectionListVC: UITableViewController,PHPhotoLibraryChangeObserver{

    var delegate: PhotoPickerDelegate?
    var selectedAssets: SelectedAssets? = SelectedAssets()
    
    private let sectionNames = ["","","相册"]
    private var userAlbums: PHFetchResult!
    private var userFavorites: PHFetchResult!
    
    deinit {
PHPhotoLibrary.sharedPhotoLibrary().unregisterChangeObserver(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)

        PHPhotoLibrary.requestAuthorization { status in
            dispatch_async(dispatch_get_main_queue()) {
                switch status {
                case .Authorized:
                    // 2
                    self.fetchCollections()
                    self.tableView.reloadData()
                default:
                    // 3
                    self.showNoAccessAlertAndCancel()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Actions
    @IBAction func donePressed(sender: AnyObject) {
        if selectedAssets != nil {
            delegate?.didSelect(self.selectedAssets!.assets)
        }
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        delegate?.didCancel()
    }
    func fetchCollections() {
        userAlbums = PHCollectionList.fetchTopLevelUserCollectionsWithOptions(nil)
        userFavorites = PHAssetCollection.fetchAssetCollectionsWithType(.SmartAlbum,
            subtype:.SmartAlbumFavorites,
            options: nil)
    }
    
    
    func showNoAccessAlertAndCancel() {
        let alert = UIAlertController(title: "权限未授予", message: "请在设置/隐私中授予App访问照片权限", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: { action in
            self.cancelPressed(self)
        }))
        alert.addAction(UIAlertAction(title: "设置", style: .Default, handler: { action in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
            return
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionNames.count
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0: // Selected Section
            return 1
        case 1: // All Photos + Favorites
            return 1 + (userFavorites?.count ?? 0)
        case 2: // Albums
            return userAlbums?.count ?? 0
        default:
            return 0
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idCell", forIndexPath: indexPath) as UITableViewCell
        cell.detailTextLabel?.text = ""
        
        // Populate the table cell
        switch(indexPath.section) {
        case 0:
            // Selected
            cell.textLabel?.text = "已选"
            cell.detailTextLabel?.text = "\(selectedAssets?.assets.count)"
            break
        case 1:
            if (indexPath.row == 0) {
                // All Photos
                cell.textLabel?.text = "全部照片"
            } else {
                // Favorites
                let favorites = userFavorites[indexPath.row - 1]
                    as PHAssetCollection
                cell.textLabel?.text = favorites.localizedTitle
                if (favorites.estimatedAssetCount != NSNotFound) {
                    cell.detailTextLabel!.text = "\(favorites.estimatedAssetCount)"
                }
            }
        case 2:
            // Albums
            let album = userAlbums[indexPath.row]
                as PHAssetCollection
            cell.textLabel?.text = album.localizedTitle
            if (album.estimatedAssetCount != NSNotFound) {
                cell.detailTextLabel!.text = "\(album.estimatedAssetCount)"
            }
            break
        default:
            break
        }
        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let destination = segue.destinationViewController
            as AssetListVC
        destination.selectedAssets = selectedAssets
        let cell = sender as UITableViewCell
        destination.title = cell.textLabel?.text
        let options = PHFetchOptions()
        options.sortDescriptors =
            [NSSortDescriptor(key: "creationDate", ascending: true)]
        let indexPath = tableView.indexPathForCell(cell)!
        switch (indexPath.section) {
        case 0:
            // Selected
            destination.fetchResults = nil
            break
        case 1:
            if indexPath.row == 0 {
                // All Photos
                destination.fetchResults =
                    PHAsset.fetchAssetsWithOptions(options)
            } else {
                // Favorites
                let favorites = userFavorites[indexPath.row - 1]
                    as PHAssetCollection
                destination.fetchResults =
                    PHAsset.fetchAssetsInAssetCollection(favorites,
                        options: options)
            }
        case 2:
            // Albums
            let album = userAlbums[indexPath.row] as PHAssetCollection
            destination.fetchResults =
                PHAsset.fetchAssetsInAssetCollection(album,
                    options: options)
        default:
            break
        }
    }
    func photoLibraryDidChange(changeInstance: PHChange!) {
        dispatch_async(dispatch_get_main_queue()) {
            var updatedFetchResults = false
            // 1
            var changeDetails: PHFetchResultChangeDetails? =
            changeInstance.changeDetailsForFetchResult(self.userAlbums)
            if let changes = changeDetails {
                self.userAlbums = changes.fetchResultAfterChanges!
                updatedFetchResults = true
            }
            
            changeDetails = changeInstance.changeDetailsForFetchResult(
                self.userFavorites)
            if let changes = changeDetails {
                self.userFavorites = changes.fetchResultAfterChanges!
                updatedFetchResults = true
            }
            // 2
            if updatedFetchResults {
                self.tableView.reloadData()
            }
        }
    }

}
