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
    var isMoreDataLoading = false
    var activityIndicator: UIActivityIndicatorView?
    
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
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: .valueChanged)
        tweetsTableView.insertSubview(refreshControl, at: 0)
        
        let footerHeight: CGFloat = 60.0
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: tweetsTableView.contentSize.height, width: tweetsTableView.bounds.size.width, height: footerHeight))
        activityIndicator?.activityIndicatorViewStyle = .gray
        activityIndicator?.hidesWhenStopped = true
        tweetsTableView.addSubview(activityIndicator!)
        
        var insets = tweetsTableView.contentInset
        insets.bottom += footerHeight
        tweetsTableView.contentInset = insets
        
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
    
    func getTweets(refreshControl: UIRefreshControl? = nil) {
        TwitterClient.sharedInstance!.getHomeTimeline(success: { [unowned self] (tweets: [Tweet]) in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
            self.firstLoad = false
            if let refresh = refreshControl {
                refresh.endRefreshing()
            }
            print("No. of tweets loaded: \(self.tweets.count)")
        }) { (error: Error) in
            print("error: \(error.localizedDescription)")
        }
    }
    
    func loadMoreTweets() {
        let currentTweetCount = tweets.count
        TwitterClient.sharedInstance!.getHomeTimeline(tweetCount: currentTweetCount + 20, success: { [unowned self] (tweets: [Tweet]) in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
            self.firstLoad = false
            self.isMoreDataLoading = false
            print("No. of tweets loaded: \(self.tweets.count)")
        }) { (error: Error) in
            print("error: \(error.localizedDescription)")
        }
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        getTweets(refreshControl: refreshControl)
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

extension TweetsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isMoreDataLoading {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tweetsTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tweetsTableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tweetsTableView.isDragging) {
                isMoreDataLoading = true
                
                loadMoreTweets()
            }
        }
    }
    
}
