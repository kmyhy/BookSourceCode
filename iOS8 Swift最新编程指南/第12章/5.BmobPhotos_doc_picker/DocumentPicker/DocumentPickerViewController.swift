//
//  DocumentPickerViewController.swift
//  DocumentPicker
//
//  Created by yanghongyan on 14/12/7.
//  Copyright (c) 2014年 yanghongyan. All rights reserved.
//

import UIKit

class DocumentPickerViewController: UIDocumentPickerExtensionViewController,BmobPhotoListDelegate {
    
    @IBAction func openDocument(sender: AnyObject?) {
        let documentURL = self.documentStorageURL.URLByAppendingPathComponent("Untitled.txt")
        
        // TODO: if you do not have a corresponding file provider, you must ensure that the URL returned here is backed by a file
        self.dismissGrantingAccessToURL(documentURL)
    }
    
    override func prepareForPresentationInMode(mode: UIDocumentPickerMode) {
        super.prepareForPresentationInMode(mode)
        
        let vc = self.childViewControllers;
        let nav = vc.first as UINavigationController
        
        let thumbController = nav.topViewController as BmobPhotoListVC
        
        thumbController.documentPickerMode = mode
        thumbController.navigationController?.setNavigationBarHidden(true, animated: false)
        if mode == .ExportToService || mode == .MoveToService {
            thumbController.performSegueWithIdentifier("upload", sender: nil)
        } else {
            thumbController.delegate = self
        }
    }
    // MARK: - BmobPhotoListDelegate
    func didSelect(photo: BmobObject) {
        // 1
        if let file = photo.objectForKey("file") as? BmobFile{
            // 2
            if let imageUrl = NSURL(string: file.url){
                //3
                let filename = file.name
                let outUrl = documentStorageURL.URLByAppendingPathComponent(filename)
                // 4
                let coordinator = NSFileCoordinator()
                coordinator.coordinateWritingItemAtURL(outUrl,
                    options: .ForReplacing,
                    error: nil,
                    byAccessor: { newURL in
                        // 5
                        if let data = NSData(contentsOfURL:imageUrl){
                            data.writeToURL(newURL, options: .AtomicWrite, error: nil)
                        }
                })
                // 6
                dismissGrantingAccessToURL(outUrl)
            }
        }
    }
}
