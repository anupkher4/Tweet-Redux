//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Anup Kher on 4/16/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController, RetweetCellDelegate {
    @IBOutlet weak var tweetDetailTableView: UITableView!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = UIColor(red: 29/255.0, green: 161/255.0, blue: 242/255.0, alpha: 1.0)
        navigationController?.navigationBar.tintColor = UIColor.white
        
        let tweetLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        tweetLabel.text = "Tweet"
        tweetLabel.textColor = UIColor.white
        
        navigationItem.titleView = tweetLabel
        
        let replyButton = UIBarButtonItem(title: "Reply", style: .plain, target: self, action: #selector(replyClicked(sender:)))
        
        navigationItem.rightBarButtonItem = replyButton
        
        tweetDetailTableView.delegate = self
        tweetDetailTableView.dataSource = self
        tweetDetailTableView.estimatedRowHeight = 100
        tweetDetailTableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func replyClicked(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "tweetToCompose", sender: sender)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tweetToCompose" {
            let navigationVc = segue.destination as! UINavigationController
            let destinationVc = navigationVc.topViewController as! ComposeTweetViewController
            if let tweet = self.tweet {
                if let tweetUsername = tweet.user?.screenname {
                    destinationVc.replyToTweetId = "\(tweet.id)"
                    destinationVc.replyUserHandle = tweetUsername
                    destinationVc.isAReply = true
                }
            }
        }
    }
    
    // Retweet Cell Delegate methods
    
    func userDidRetweet(tweet: Tweet) {
        self.tweet = tweet
        tweetDetailTableView.reloadData()
    }
    
    func userDidFavorite(tweet: Tweet) {
        self.tweet = tweet
        tweetDetailTableView.reloadData()
    }
    
    func userDidReply() {
        performSegue(withIdentifier: "tweetToCompose", sender: self)
    }
}

extension TweetDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetDetailCell", for: indexPath) as! TweetDetailTableViewCell
            if let tweet = self.tweet {
                cell.tweet = tweet
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CountCell", for: indexPath) as! CountTableViewCell
            if let tweet = self.tweet {
                cell.tweet = tweet
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RetweetCell", for: indexPath) as! RetweetTableViewCell
            cell.delegate = self
            if let tweet = self.tweet {
                print("passing in id: \(tweet.id)")
                cell.tweet = tweet
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
