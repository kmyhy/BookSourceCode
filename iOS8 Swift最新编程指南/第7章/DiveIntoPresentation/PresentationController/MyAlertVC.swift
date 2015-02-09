//
//  MyAlertVC.swift
//  PresentationController
//
//  Created by yanghongyan on 14/10/31.
//  Copyright (c) 2014年 yanghongyan. All rights reserved.
//

import UIKit

class MyAlertVC: UIViewController {

    @IBAction func close(sender: AnyObject) {
        presentingViewController!.dismissViewControllerAnimated(true,
            completion: nil)
    }
    @IBOutlet var lbMessage: UILabel!
    var message:NSString!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(animated: Bool) {
        if lbMessage != nil {
            lbMessage.text = message;
        }
    }
}
