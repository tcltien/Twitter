//
//  TwitterViewController.swift
//  Twitter
//
//  Created by Le Huynh Anh Tien on 7/20/16.
//  Copyright © 2016 Tien Le. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import AFNetworking

class TwitterViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var tweets = [Tweet]()
    var refreshControl = UIRefreshControl()


    override func viewDidLoad() {
        
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.insertSubview(refreshControl, atIndex: 0)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.delegate = self
        tableView.dataSource = self
        getHomeTimeLine()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
  */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var indexPath : Int?
        if segue.identifier == "toTweetViewController" {
            let cell = sender as! TwitterCell
            indexPath =  tableView.indexPathForCell(cell)!.row
            let tweet = tweets[indexPath!]
            
            let detailVC = segue.destinationViewController as! TweetViewController
            detailVC.tweet = tweet
        }
        if segue.identifier == "segueNewTweet" {
        }
        

        
    }
 

    func refreshControlAction(refreshControl: UIRefreshControl) {
        getHomeTimeLine()
    }
    
    func getHomeTimeLine() {
        TwitterClient.shareInstance.homeTimeLine({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }) { (error: NSError) -> () in
            print("Error \(error.localizedDescription)")
        }

    }
    @IBAction func onLogOut(sender: AnyObject) {
        TwitterClient.shareInstance.logout()
    }
}

extension TwitterViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TwitterCell", forIndexPath: indexPath) as! TwitterCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
}
