//
//  CorrectAnswerVC.swift
//  PresentationController
//
//  Created by yanghongyan on 14/10/26.
//  Copyright (c) 2014年 yanghongyan. All rights reserved.
//

import UIKit

class CorrectAnswerVC: UIViewController {
    @IBOutlet weak var answerLabel: UILabel!
    
    var correctAnswer=""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        answerLabel.text = correctAnswer
        
        var detailsButton: UIBarButtonItem =
        UIBarButtonItem(title: "关闭",
            style: UIBarButtonItemStyle.Plain,
            target: self, action: "close:")
        
        self.navigationItem.rightBarButtonItem = detailsButton
    }
    func close(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
