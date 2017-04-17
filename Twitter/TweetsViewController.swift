//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Anup Kher on 4/13/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {
    @IBOutlet weak var tweetsTableView: UITableView!

    var tweets: [Tweet] = []
    var firstLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 29/255.0, green: 161/255.0, blue: 242/255.0, alpha: 1.0)
        navigationController?.navigationBar.tintColor = UIColor.white
        
        let titleImageView = UIImageView(image: UIImage(named: "twitter_white"))
        navigationItem.titleView = titleImageView
        
        tweetsTableView.delegate = self
        tweetsTableView.dataSource = self
        tweetsTableView.estimatedRowHeight = 150
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        
        getTweets()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !firstLoad {
            getTweets()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func userDidLogout(_ sender: UIBarButtonItem) {
        TwitterClient.sharedInstance!.logout()
    }
    
    func getTweets() {
        TwitterClient.sharedInstance!.getHomeTimeline(success: { [unowned self] (tweets: [Tweet]) in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
            self.firstLoad = false
        }) { (error: Error) in
            print("error: \(error.localizedDescription)")
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tweetToDetail" {
            let tweetDetailVc = segue.destination as! TweetDetailViewController
            let indexPath = tweetsTableView.indexPath(for: sender as! TweetTableViewCell)
            let selectedTweet = tweets[indexPath!.row]
            tweetDetailVc.tweet = selectedTweet
        }
    }

}

extension TweetsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetTableViewCell
        
        let tweet = tweets[indexPath.row]
        cell.tweet = tweet
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
