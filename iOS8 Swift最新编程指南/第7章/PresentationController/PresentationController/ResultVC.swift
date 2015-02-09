//
//  ResultVC.swift
//  PresentationController
//
//  Created by yanghongyan on 14/10/27.
//  Copyright (c) 2014年 yanghongyan. All rights reserved.
//

import UIKit
protocol SearchResultSelecting {
    func searchResultSelected(question:Question)
}

class ResultVC: UITableViewController,UISearchResultsUpdating {
    var questions = Question.questions()
    var searchResults = NSMutableArray()
    var delegate:SearchResultSelecting?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(NSClassFromString("UITableViewCell"), forCellReuseIdentifier: "idCell")
    }

    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            
            return searchResults.count
    }
    
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            
            var cell =
            tableView.dequeueReusableCellWithIdentifier("idCell",
                forIndexPath: indexPath) as UITableViewCell
            let question = searchResults[indexPath.row] as Question
            
            cell.textLabel?.text = question.quizQuestion
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
    }
    override func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
            let question = searchResults[indexPath.row] as Question
            delegate?.searchResultSelected(question)
    }
    
    // #pragma mark - Search Helper
    
    func filterContentForSearchText(searchText: String) {
        searchResults.removeAllObjects()
        
        let predicate = NSPredicate(format:
            "SELF.quizQuestion contains[c] %@", searchText)
        
        let tempArray =
        self.questions.filteredArrayUsingPredicate(predicate!)
        
        searchResults = NSMutableArray(array: tempArray)
        
        tableView.reloadData()
    }
    
    // #pragma mark - UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(
        searchController: UISearchController) {
            
            if !searchController.active {
                return
            }
            
            filterContentForSearchText(
                searchController.searchBar.text)
    }
}
