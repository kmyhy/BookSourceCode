//
//  UploadVC.swift
//  PhotoShare
//
//  Created by yanghongyan on 15/1/7.
//  Copyright (c) 2015年 yanghongyan. All rights reserved.
//

import UIKit
import CloudKit

class UploadVC: UIViewController,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    var userName:String?

    @IBAction func uploadAction(sender: AnyObject) {
        // 1
        self.view.endEditing(true)
        // 2
        if let image = imageView.image {
            // 3
            let fileURL = generateFileURL()
            // 4
            let data = UIImageJPEGRepresentation(image, 0.9)
            var error : NSError?
            // 5
            let wrote = data.writeToURL(fileURL, options: .AtomicWrite, error: &error)
            // 6
            if (error != nil) {
                UIAlertView(title: "Error Saving Photo",
                    message: error?.localizedDescription, delegate: nil,
                    cancelButtonTitle: "OK").show()
                return
            }

            var ckfoto: CKPhoto = CKPhoto()
            ckfoto.poster = userName
            //Apple Campus location = 37.33182, -122.03118
            ckfoto.location = CLLocation(latitude: 37.33182, longitude: -122.03118)
            ckfoto.asset = fileURL
            ckfoto.description = textView.text
            showHud()
            // 9
            publicDB.saveRecord(ckfoto.record, completionHandler: { (_record, error) -> Void in
                // 10
                if error != nil {
                    self.closeHud()
                    println("创建记录失败：\(_record)\n\(error)")
                }else{
                    // 11
                    let recordRef = CKReference(record: _record, action: .DeleteSelf)
                    // 12
                    if userInfo.userRecordID != nil {
                        let userRef = CKReference(recordID:userInfo.userRecordID!, action: .None)
                        let rec = CKRecord(recordType: "PhotoUser")
                        rec.setObject(recordRef, forKey: "Photo")
                        rec.setObject(userRef, forKey: "User")
                        publicDB.saveRecord(rec){ (_record, error) -> Void in
                            if error != nil {
                                println("创建记录失败：\(_record)\n\(error)")
                            }
                            self.closeHud()
                            return
                        }
                    }else{
                        // 13
                        self.closeHud()
                    }
                    // 14
                    NSFileManager.defaultManager().removeItemAtURL(fileURL, error: nil)
                }
                return
            })
        
        }
    }
    @IBAction func pickImageAction(sender: AnyObject) {
        imagePickerShow(.PhotoLibrary)
    }
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(textView: UITextView) {
        placeHolderLabel.hidden = countElements(textView.text) > 0
    }
    func imagePickerShow(sourceType:UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    //MARK: -  <UIImagePickerControllerDelegate>
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        dismissViewControllerAnimated(true, completion: nil)
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = selectedImage
        }
    }
    func generateFileURL() -> NSURL {
        let fileManager = NSFileManager.defaultManager()
        let fileArray: NSArray = fileManager.URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)
        let cacheURL = fileArray.lastObject as NSURL
        let fileURL = cacheURL.URLByAppendingPathComponent(NSUUID().UUIDString).URLByAppendingPathExtension("jpg")
        
        if let filePath = cacheURL.path {
            if !fileManager.fileExistsAtPath(filePath) {
                fileManager.createDirectoryAtPath(filePath, withIntermediateDirectories: true, attributes: nil, error: nil)
            }
        }
        
        return fileURL
    }

}
