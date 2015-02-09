//
//  ViewController.swift
//  AdaptiveDemo2
//
//  Created by chen neng on 14-10-2.
//  Copyright (c) 2014年 kmyhy. All rights reserved.
//

import UIKit

class ViewController: UITableViewController,UITableViewDelegate,UITableViewDataSource{
    
    var container:PostCollectionContainer!
    var posts:[Post]=[]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var post=Post()
        post.avatarImage=UIImage(named: "Contact")
        post.poster="lifedim"
        post.postTime="2014-6-25 17:34:07"
        post.title="构造过程（Initialization"
        post.content="属性观察器监控和响应属性值的变化，每次属性被设置值的时候都会调用属性观察器，甚至新的值和现在的值相同的时候也不例外。"+"\n"+"可以为除了延迟存储属性之外的其他存储属性添加属性观察器，也可以通过重载属性的方式为继承的属性（包括存储属性和计算属性）添加属性观察器。"
        posts.append(post)
        
        post=Post()
        post.avatarImage=UIImage(named: "Contact")
        post.poster="lifedim"
        post.postTime="2014-6-25 17:34:07"
        post.title="默认构造器"
        post.content="构造器代理的实现规则和形式"
        posts.append(post)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier( "PostCell", forIndexPath: indexPath) as PostTableViewCell
        cell.post=posts[indexPath.row]
//        cell.avatarImageView.image=posts[indexPath.row].avatarImage
//        cell.contentLabel.text=posts[indexPath.row].content
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if container == nil {
        performSegueWithIdentifier("toPostViewController", sender: indexPath)
        }else{
            container.post=posts[indexPath.row]
        }
        
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier=="toPostViewController" {
            if let indexPath = sender as? NSIndexPath {
                let dest=segue.destinationViewController as PostViewController
                dest.tempPost=posts[indexPath.row]
            }
        }
    }
}

