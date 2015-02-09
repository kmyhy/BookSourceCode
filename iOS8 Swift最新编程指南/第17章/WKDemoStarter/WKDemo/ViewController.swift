//
//  ViewController.swift
//  WKDemo
//
//  Created by yanghongyan on 15/1/27.
//  Copyright (c) 2015年 yanghongyan. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var stopButton: UIBarButtonItem!
    @IBOutlet weak var categoryButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryButton.enabled = false
        backButton.enabled = false
        forwardButton.enabled = false;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func backAction(sender: AnyObject) {
    }
    @IBAction func stopAction(sender: AnyObject) {
    }
    @IBAction func forwardAction(sender: AnyObject) {
    }
}

