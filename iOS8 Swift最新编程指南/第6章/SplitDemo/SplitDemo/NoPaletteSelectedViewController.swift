//
//  NoPaletteSelectedViewController.swift
//  SplitDemo
//
//  Created by yanghongyan on 14-10-15.
//  Copyright (c) 2014年 kmyhy. All rights reserved.
//

import UIKit

class NoPaletteSelectedViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let svc = splitViewController {
            navigationItem.setLeftBarButtonItem( svc.displayModeButtonItem(), animated: true)
        }
    }
}
