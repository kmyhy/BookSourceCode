//
//  PaperVC.swift
//  PresentationController
//
//  Created by yanghongyan on 14/10/22.
//  Copyright (c) 2014年 yanghongyan. All rights reserved.
//

import UIKit

class PaperVC: UIViewController,UIPopoverPresentationControllerDelegate{

    @IBOutlet weak var quiz5Answer: UIButton!
    @IBOutlet weak var quiz4Answer: UIButton!
    @IBOutlet weak var quiz3Answer: UIButton!
    @IBOutlet weak var quiz2Answer: UIButton!
    @IBOutlet weak var QuizDescription: UILabel!
    @IBOutlet weak var quiz1Answer: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setPaperShow(false)
        let detailsButton: UIBarButtonItem =
        UIBarButtonItem(title: "查看答案",
            style: UIBarButtonItemStyle.Plain,
            target: self, action: "displayPopover:")
        navigationItem.rightBarButtonItem = detailsButton
    }
    func displayPopover(sender:UIBarButtonItem){
        // 1
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        
        var contentViewController : CorrectAnswerVC = storyboard.instantiateViewControllerWithIdentifier(
            "idCorrectAnswerVC") as CorrectAnswerVC
        // 2
        if question != nil {
                contentViewController.correctAnswer = question!.quizAnswers[0]
        }
        // 3
        contentViewController.modalPresentationStyle = UIModalPresentationStyle.Popover;
        // 4
        var detailPopover: UIPopoverPresentationController = contentViewController.popoverPresentationController!
        
        detailPopover.delegate = self
        detailPopover.barButtonItem = sender;
        // 5
        presentViewController(contentViewController,
            animated: true, completion:nil)
    }
    var question: Question? {
        didSet{
            configureView()
        }
    }
    func configureView() {
        if question != nil {
            
            if QuizDescription != nil {
                QuizDescription.text = question!.quizQuestion;
            }
            
            if quiz1Answer != nil {
                quiz1Answer.setTitle(question!.quizAnswers[0],forState:UIControlState.Normal)
            }
            
            if quiz2Answer != nil {
                quiz2Answer.setTitle(question!.quizAnswers[1], forState:UIControlState.Normal)
            }
            
            if quiz3Answer != nil {
                quiz3Answer.setTitle(question!.quizAnswers[2], forState:UIControlState.Normal)
            }
            
            if quiz4Answer != nil {
                quiz4Answer.setTitle(question!.quizAnswers[3],forState:UIControlState.Normal)
            }
            
            if question!.quizAnswers.count > 4 {
                if quiz5Answer != nil {
                    quiz5Answer.setTitle(question!.quizAnswers[4], forState: UIControlState.Normal)
                }
            }
            setPaperShow(true)
        }
    }
    override func viewDidAppear(animated: Bool) {
        configureView()
    }

    func setPaperShow(b:Bool){
        QuizDescription?.hidden = !b
        quiz5Answer?.hidden = !b
        quiz4Answer?.hidden = !b
        quiz3Answer?.hidden = !b
        quiz2Answer?.hidden = !b
        quiz1Answer?.hidden = !b
        if question?.quizAnswers.count <= 4 {
            quiz5Answer?.hidden = true
        }
    }
    @IBAction func quizAnswerButtonPressed(sender: UIButton) {
        var message = ""
        if sender == quiz1Answer {
            message = "恭喜你，答对了！"
        } else {
            message = "呃，再试试！"
        }
        var alert = UIAlertController(title:nil, message:message, preferredStyle:UIAlertControllerStyle.ActionSheet)
        alert.popoverPresentationController?.sourceView = view
        alert.popoverPresentationController?.sourceRect = sender.frame
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(alert :UIAlertAction!) in 
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    // MARK: - UIAdaptivePresentationControllerDelegate
    func adaptivePresentationStyleForPresentationController( controller: UIPresentationController!) ->
        UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    func presentationController(controller: UIPresentationController!, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle)
        -> UIViewController! {
        let navController = UINavigationController(rootViewController:
        controller.presentedViewController)
        return navController
    }
}
