//
//  TopicListVC.swift
//  PresentationController
//
//  Created by yanghongyan on 14/10/22.
//  Copyright (c) 2014年 yanghongyan. All rights reserved.
//

import UIKit

class TopicListVC: UITableViewController,SearchResultSelecting {
    var searchController: UISearchController? = nil
    var questions:NSArray?
    var selectedQuestion: Question?
    var pagerVC: PaperVC? = nil
    func addSearchBar() {
        var resultsController = ResultVC()
//        var resultsController = self.storyboard?.instantiateViewControllerWithIdentifier("idResultVC") as ResultVC
        resultsController.questions = questions!
        resultsController.delegate = self
        searchController = UISearchController(searchResultsController: resultsController)
        searchController!.searchResultsUpdater = resultsController
        searchController!.searchBar.frame = CGRect(
        x: searchController!.searchBar.frame.origin.x,
        y: searchController!.searchBar.frame.origin.y, width: searchController!.searchBar.frame.size.width, height: 44.0)
        tableView.tableHeaderView = searchController!.searchBar;
        self.definesPresentationContext = true
    }
    func searchResultSelected(question:Question){
            pagerVC?.question = question
            showDetailViewController(UINavigationController(rootViewController: pagerVC!)!, sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questions = Question.questions()
        
        let controllers = splitViewController!.viewControllers
        pagerVC =
            controllers[controllers.endIndex-1].topViewController
            as? PaperVC
        
        // Set the details controller with the
        // first country in the array
        let question = questions?[0] as Question
        pagerVC?.question = question
        addSearchBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //==============Show a navigation bar on detail view controller=========
    override func prepareForSegue(segue: UIStoryboardSegue,
        sender: AnyObject?) {
            
//            if segue.identifier == "showDetail" {
//                pagerVC?.question = selectedQuestion
//            }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if questions == nil {
            return 0
        }else{
            return questions!.count
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell =
        tableView.dequeueReusableCellWithIdentifier("idCell",
            forIndexPath: indexPath)as UITableViewCell
        
        let question = questions?[indexPath.row] as Question
        cell.textLabel?.text = "第 \(indexPath.row+1) 题"
        return cell
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    override func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
            selectedQuestion = questions?[indexPath.row] as? Question
            pagerVC?.question = selectedQuestion
            showDetailViewController(UINavigationController(rootViewController: pagerVC!)!, sender: self)
    
    }
}
