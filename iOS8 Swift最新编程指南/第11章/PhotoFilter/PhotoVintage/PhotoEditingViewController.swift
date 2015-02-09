//
//  PhotoEditingViewController.swift
//  PhotoVintage
//
//  Created by yanghongyan on 14/11/27.
//  Copyright (c) 2014年 yanghongyan. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class PhotoEditingViewController: UIViewController, PHContentEditingController {

    @IBOutlet var editingImageView: UIImageView?
    @IBOutlet var slider: UISlider?
    
    var input: PHContentEditingInput?
    var filter: CIFilter!
    var beginImage: CIImage!
    let formatIdentifier = "com.ydtf.PhotoFilter"
    let formatVersion    = "1.0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func sliderValueChanged(sender: UISlider){
        
        let sliderValue = sender.value
        
        filter.setValue(sliderValue, forKey: kCIInputIntensityKey)
        let outputImage = filter.outputImage
        editingImageView?.image = UIImage(CIImage: outputImage)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - PHContentEditingController

    func canHandleAdjustmentData(adjustmentData: PHAdjustmentData?) -> Bool {
         return adjustmentData?.formatIdentifier == formatIdentifier &&
        adjustmentData?.formatVersion == formatVersion
    }

    func startContentEditingWithInput(contentEditingInput: PHContentEditingInput?, placeholderImage: UIImage) {
        input = contentEditingInput
        
        beginImage = CIImage(image: input?.displaySizeImage)
        filter = CIFilter(name: "CISepiaTone")
        filter.setValue(beginImage, forKey: kCIInputImageKey)
        
        if let adjustmentData = contentEditingInput?.adjustmentData {
            let value = NSKeyedUnarchiver.unarchiveObjectWithData(adjustmentData.data) as NSNumber
            filter.setValue(value, forKey: kCIInputIntensityKey)
            slider?.value = value.floatValue
        }
        else {
            filter.setValue(0.5, forKey: kCIInputIntensityKey)
        }
        
        let outputImage : CIImage = filter.outputImage
        editingImageView?.image = UIImage(CIImage: outputImage)
    }

    func finishContentEditingWithCompletionHandler(completionHandler: ((PHContentEditingOutput!) -> Void)!) {
        dispatch_async(dispatch_get_global_queue(CLong(DISPATCH_QUEUE_PRIORITY_DEFAULT), 0)) {
            // 1
            let output = PHContentEditingOutput(contentEditingInput: self.input)
            
            let archivedData = NSKeyedArchiver.archivedDataWithRootObject(self.filter.valueForKey(kCIInputIntensityKey)!)
            let newAdjustmentData = PHAdjustmentData(formatIdentifier: self.formatIdentifier,
                formatVersion: self.formatVersion,
                data: archivedData)
            output.adjustmentData = newAdjustmentData
            
            // Write the JPEG Data
            let fullSizeImage = CIImage(contentsOfURL: self.input?.fullSizeImageURL)
            UIGraphicsBeginImageContext(fullSizeImage.extent().size);
            self.filter.setValue(fullSizeImage, forKey: kCIInputImageKey)
//            UIImage(CIImage: self.filter.outputImage.takeUnretainedValue()).drawInRect(fullSizeImage.extent())
            let context = CIContext(options: nil)
            let outputImage = UIImage(CGImage: context.createCGImage(self.filter.outputImage, fromRect: self.filter.outputImage.extent()))
            let jpegData = UIImageJPEGRepresentation(outputImage, 1.0)
            UIGraphicsEndImageContext()
            
            jpegData.writeToURL(output.renderedContentURL, atomically: true)
            
            // Call completion handler to commit edit to Photos.
            completionHandler?(output)
            
            // Clean up temporary files, etc.
        }
    }

    var shouldShowCancelConfirmation: Bool {
        // Determines whether a confirmation to discard changes should be shown to the user on cancel.
        // (Typically, this should be "true" if there are any unsaved changes.)
        return false
    }

    func cancelContentEditing() {
        // Clean up temporary files, etc.
        // May be called after finishContentEditingWithCompletionHandler: while you prepare output.
    }

}
