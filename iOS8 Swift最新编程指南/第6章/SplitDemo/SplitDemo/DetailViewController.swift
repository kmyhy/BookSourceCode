//
//  DetailViewController.swift
//  SplitDemo
//
//  Created by chen neng on 14-10-5.
//  Copyright (c) 2014年 kmyhy. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,PaletteDisplayContainer {

    @IBOutlet weak var color1: UILabel!

    @IBOutlet weak var color2: UILabel!
    
    @IBOutlet weak var color3: UILabel!
    
    @IBOutlet weak var color4: UILabel!
    
    @IBOutlet weak var color5: UILabel!
    
    var detailItem: ColorPalette?
    func configureView() {
        // Update the user interface for the detail item.
        if let colors = self.detailItem?.children{
            if colors.count >= 5 {
                color1.text=colors[0].name
                color2.text=colors[1].name
                color3.text=colors[2].name
                color4.text=colors[3].name
                color5.text=colors[4].name
                
                color1.backgroundColor=UIColorFromHexString(color1.text!)
                color2.backgroundColor=UIColorFromHexString(color2.text!)
                color3.backgroundColor=UIColorFromHexString(color3.text!)
                color4.backgroundColor=UIColorFromHexString(color4.text!)
                color5.backgroundColor=UIColorFromHexString(color5.text!)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let _ = detailItem {
            makeAllContentHidden(false)
            self.configureView()
        }else{
            if let empty = storyboard?
                .instantiateViewControllerWithIdentifier(
                "NoPaletteSelected") {
                    showViewController(empty, sender: self)
            }
            makeAllContentHidden(true)
            
        }
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let svc = splitViewController {
            if !svc.collapsed {
            navigationItem.setLeftBarButtonItem( svc.displayModeButtonItem(), animated: true)
            navigationItem.leftItemsSupplementBackButton = true
            navigationItem.hidesBackButton = false
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func makeAllContentHidden(hidden: Bool) {
        for subview in view.subviews as [UIView] {
            subview.hidden = hidden
        }
        if hidden {
            title = ""
        }
    }
    func displayingPalette() -> ColorPalette? {
        return detailItem
    }

}

