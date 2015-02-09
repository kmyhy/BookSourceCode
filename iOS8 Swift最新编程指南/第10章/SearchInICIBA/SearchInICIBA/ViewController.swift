//
//  ViewController.swift
//  SearchInICIBA
//
//  Created by yanghongyan on 14/11/20.
//  Copyright (c) 2014年 yanghongyan. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if extensionContext != nil {
            for item: AnyObject in self.extensionContext!.inputItems {
                let inputItem = item as NSExtensionItem
                for provider: AnyObject in inputItem.attachments! {
                    let itemProvider = provider as NSItemProvider
                    if itemProvider.hasItemConformingToTypeIdentifier(kUTTypePropertyList as NSString) {
                        weak var weakSearchTextField = self.textField
                        itemProvider.loadItemForTypeIdentifier(kUTTypePropertyList as NSString, options: nil, completionHandler: {(dictionary, error) in
                            if let resultsDictionary = dictionary as? NSDictionary {
                                let resultItem: NSDictionary! = resultsDictionary.objectForKey(NSExtensionJavaScriptPreprocessingResultsKey as NSString) as NSDictionary
                                let selectedText: String = resultItem.objectForKey("selectedText") as String
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.textField.text = selectedText;
                                }
                            }
                        })
                    }
                }
            }
        }
    }

    @IBAction func searchAction(sender: AnyObject) {
        view.endEditing(true)
        let searchTextString = textField.text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let urlString = "http://www.iciba.com/\(searchTextString!)"
        var url = NSURL(string: urlString)
        dispatch_async(dispatch_get_main_queue()) {
            self.webView.loadRequest(NSURLRequest(URL: url!))
        }
    }
    @IBAction func backAction(sender: AnyObject) {
        if extensionContext != nil {
            self.extensionContext!.completeRequestReturningItems(self.extensionContext!.inputItems, completionHandler: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

