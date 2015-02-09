//
//  ViewController.swift
//  DocumentPickerTest
//
//  Created by yanghongyan on 14/12/22.
//  Copyright (c) 2014年 yanghongyan. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController,UIDocumentPickerDelegate {
    var lastURL: NSURL?
    let docType = kUTTypeImage as NSString
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func open(sender: AnyObject) {
        let documentPicker = UIDocumentPickerViewController(documentTypes:[docType], inMode: .Open)
        documentPicker!.delegate = self
        presentViewController(documentPicker!, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - DocumentPicker Delegate
    
    func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
        dismissViewControllerAnimated(true, completion: nil)
        lastURL = url
        println("pick url:\(url.absoluteString!)")
        switch controller.documentPickerMode {
        case .Open:
            openImage(url)
        default:
            break
        }
    }
    func documentPickerWasCancelled(controller: UIDocumentPickerViewController!) {// Cancel operation when Done button is clicked
        imageView.image = nil
    }
    //MARK: - Private methods
    func openImage(url : NSURL) {
        let accessing = url.startAccessingSecurityScopedResource() //1
        if accessing {
            let fileCoordinator = NSFileCoordinator(filePresenter: nil)
            fileCoordinator.coordinateReadingItemAtURL(url,
                options: .WithoutChanges,
                error: nil) { newURL in
                    self.imageView.setImageWithUrl(newURL, completionHandler: {(_)in})
            }
            url.stopAccessingSecurityScopedResource() //2
        }
    }

}

