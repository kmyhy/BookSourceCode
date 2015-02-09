//
//  ViewController.swift
//  WKDemo
//
//  Created by yanghongyan on 15/1/27.
//  Copyright (c) 2015年 yanghongyan. All rights reserved.
//

import UIKit
import WebKit

let MessageHandler = "didFetchMenus"

class ViewController: UIViewController,WKNavigationDelegate,WKScriptMessageHandler {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var stopButton: UIBarButtonItem!
    @IBOutlet weak var categoryButton: UIBarButtonItem!
    
    var webView: WKWebView!

    var menuItems: [Menu] = []
    required init(coder aDecoder:NSCoder){
        super.init(coder: aDecoder)
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.addUserScript(javascriptObject("hideNv"))
        configuration.userContentController.addUserScript(javascriptObject("fetchMenus"))
        configuration.userContentController.addScriptMessageHandler(self, name: MessageHandler)
        webView = WKWebView(frame: CGRectZero, configuration:configuration)
        self.webView!.navigationDelegate = self
    }
    

    func javascriptObject(fromName:String)->WKUserScript {
        let filePath = NSBundle.mainBundle().pathForResource(fromName, ofType: "js")
        let js = String(contentsOfFile:filePath!, encoding:NSUTF8StringEncoding, error: nil)
        let scriptObj = WKUserScript(source: js!, injectionTime: .AtDocumentEnd, forMainFrameOnly: true)
        return scriptObj
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryButton.enabled = false
        backButton.enabled = false
        forwardButton.enabled = false;
        view.addSubview(webView)
        view.insertSubview(webView!, belowSubview: progressView)
        webView!.setTranslatesAutoresizingMaskIntoConstraints(false)
        let widthConstraint = NSLayoutConstraint(item: webView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        view.addConstraint(widthConstraint)
        let heightConstraint = NSLayoutConstraint(item: webView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: -44)
        view.addConstraint(heightConstraint)
        let URL = NSURL(string:"http://www.it007.com/")
        let request = NSURLRequest(URL:URL!)
        webView.loadRequest(request)
        webView.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
        webView.addObserver(self, forKeyPath: "title", options: .New, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        NSNotificationCenter.defaultCenter()
.addObserver(self, selector: "menuSelected:", name: menuItemSelected, object: nil)
    }
    func menuSelected(notification:NSNotification){
        let menu = notification.object as Menu
        title = menu.title
        let URL = NSURL(string:menu.url)
        let request = NSURLRequest(URL:URL!)
        webView.loadRequest(request)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func backAction(sender: AnyObject) {
        webView.goBack()
    }
    @IBAction func forwardAction(sender: AnyObject) {
        webView.goForward()
    }
    @IBAction func stopAction(sender: AnyObject) {
        if (webView.loading) {
            webView.stopLoading()
        } else {
            let request = NSURLRequest(URL:webView.URL!)
            webView.loadRequest(request)
        }
    }
    // MARK: NSKeyValueObserving
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<()>) {
        if (keyPath == "loading") {
            forwardButton.enabled = webView.canGoForward
            backButton.enabled = webView.canGoBack
            stopButton.image = webView.loading ? UIImage(named: "Cross") : UIImage(named: "Syncing")
            UIApplication.sharedApplication().networkActivityIndicatorVisible = webView.loading
        } else if (keyPath == "title") {
            title = webView.title
        }else if (keyPath == "estimatedProgress") {
            progressView.hidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    // MARK: WKNavigationDelegate
    func webView(webView: WKWebView!, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError!) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func webView(webView: WKWebView!, decidePolicyForNavigationAction navigationAction: WKNavigationAction!, decisionHandler: ((WKNavigationActionPolicy) -> Void)!) {
        let hostname = navigationAction.request.URL.host!.lowercaseString
        if (navigationAction.navigationType == .LinkActivated && !hostname.isMatch(".it007.com$")) {
            UIApplication.sharedApplication().openURL(navigationAction.request.URL);
            decisionHandler(.Cancel)
        } else {
            decisionHandler(.Allow)
        }
    }
    func webView(webView: WKWebView!, didFinishNavigation navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
    }
    // MARK: WKScriptMessageHandler
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if (message.name == MessageHandler) {
            if let resultArray = message.body as? [Dictionary<String,
                String>] {
                menuItems.removeAll(keepCapacity: true)
                for d in resultArray {
                    let item = Menu(dictionary: d)
                    menuItems.append(item)
                }
                println("authors = \(menuItems.debugDescription)")
                categoryButton.enabled = true
            }
        }
    }
    // MARK: Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "idMenus") {
            let navController = segue.destinationViewController as
            UINavigationController
            let menusVC = navController.topViewController as
            MenusVC
            menusVC.items = menuItems
        }
    }
}

