//
//  ViewController.swift
//  BmobPhotos
//
//  Created by yanghongyan on 14/12/7.
//  Copyright (c) 2014年 yanghongyan. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        registerBmob()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func selectImageToUpload(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .SavedPhotosAlbum
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - Image Picker Delegate
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        dismissViewControllerAnimated(true, completion: nil)
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let fileData = UIImageJPEGRepresentation(selectedImage, 1)!

            uploadImage(fileData, { (success, bombObj) -> Void in
                if success {
                    let file = bombObj.objectForKey("file") as BmobFile
                    println("upload to url:\(file.url)")
                }
            })
        }
    }

}

