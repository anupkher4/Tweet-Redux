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
    
    let client = TwitterClient.sharedInstance!
    var tweets: [Tweet] = []
    var retweetState: [Int : Bool] = [:]
    var favoriteState: [Int : Bool] = [:]
    var firstLoad = true
    var isMoreDataLoading = false
    var activityIndicator: UIActivityIndicatorView?
    var selectedUser: User? = User.currentUser
    
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
    
    func didTapProfilePicture(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let index = imageView.tag
        let selectedTweet = tweets[index]
        selectedUser = selectedTweet.user!
        performSegue(withIdentifier: "tweetsToProfile", sender: sender)
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
        if segue.identifier == "tweetsToProfile" {
            let navVc = segue.destination as! UINavigationController
            let profileVc = navVc.topViewController as! ProfileViewController2
            profileVc.selectedUser = selectedUser
        }
        if segue.identifier == "tweetHomeToReply" {
            let tweet = sender as! Tweet
            let navVc = segue.destination as! UINavigationController
            let composeVc = navVc.topViewController as! ComposeTweetViewController
            if let tweetUsername = tweet.user?.screenname {
                composeVc.replyToTweetId = "\(tweet.id)"
                composeVc.replyUserHandle = tweetUsername
                composeVc.isAReply = true
            }
        }
    }

}

extension TweetsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetTableViewCell
        cell.delegate = self
        
        // Maintain cell state
        // Retweet
        if retweetState[indexPath.row] == false || retweetState[indexPath.row] == nil {
            cell.retweetButton.setImage(UIImage(named: "retweet"), for: .normal)
        } else {
            cell.retweetButton.setImage(UIImage(named: "retweet_on"), for: .normal)
        }
        // Favorite
        if favoriteState[indexPath.row] == false || favoriteState[indexPath.row] == nil {
            cell.likeButton.setImage(UIImage(named: "favorite"), for: .normal)
        } else {
            cell.likeButton.setImage(UIImage(named: "favorite_on"), for: .normal)
        }
        
        let tweet = tweets[indexPath.row]
        cell.tweet = tweet
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePicture(_:)))
        cell.profileImageView.tag = indexPath.row
        cell.profileImageView.isUserInteractionEnabled = true
        cell.profileImageView.addGestureRecognizer(tapGesture)
        
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

// MARK: - TweetTableViewCellDelegate methods

extension TweetsViewController: TweetTableViewCellDelegate {
    
    func userTappedReply(cell: UITableViewCell) {
        let indexPath = tweetsTableView.indexPath(for: cell)
        let tweet = tweets[indexPath!.row]
        performSegue(withIdentifier: "tweetHomeToReply", sender: tweet)
    }
    
    func userTappedRetweet(cell: UITableViewCell, currentState: Bool) {
        guard let indexPath = tweetsTableView.indexPath(for: cell) else {
            print("Could not get indexPath for retweet cell")
            return
        }
        let index = indexPath.row
        let tweet = tweets[index]
        
        // Maintain cell state
        if !currentState {
            if retweetState[index] != nil {
                retweetState[index] = currentState
            }
        } else {
            retweetState[index] = currentState
        }
        
        if tweet.isRetweeted {
            // Unretweet
            client.unRetweet(tweet: tweet, success: { (unretweet: Tweet?) in
                if let tweet = unretweet {
                    print("Unretweeted \(tweet.id)")
                    self.tweetsTableView.reloadData()
                } else {
                    print("Tweet was never retweeted")
                }
            }, failure: { (error: Error) in
                print("Unretweet error: \(error.localizedDescription)")
            })
        } else {
            client.retweet(tweetId: tweet.id, success: { (retweet: Tweet) in
                print("Retweeted \(retweet.id)")
                self.tweetsTableView.reloadData()
            }, failure: { (error: Error) in
                print("Retweet error: \(error.localizedDescription)")
            })
        }

    }
    
    func userTappedFavorite(cell: UITableViewCell, currentState: Bool) {
        guard let indexPath = tweetsTableView.indexPath(for: cell) else {
            print("Could not get indexPath for favorite cell")
            return
        }
        let index = indexPath.row
        let tweet = tweets[index]
        
        // Maintain cell state
        if !currentState {
            if favoriteState[index] != nil {
                favoriteState[index] = false
            }
        } else {
            favoriteState[index] = currentState
        }
        
        if tweet.isFavorited {
            // Unlike
            client.unFavorite(tweetId: tweet.id, success: { (unliked: Tweet) in
                print("Unliked \(unliked.id)")
                self.tweetsTableView.reloadData()
            }, failure: { (error: Error) in
                print("Unlike error: \(error.localizedDescription)")
            })
        } else {
            client.favorite(tweetId: tweet.id, success: { (liked: Tweet) in
                print("Liked \(liked.id)")
                self.tweetsTableView.reloadData()
            }, failure: { (error: Error) in
                print("Like error: \(error.localizedDescription)")
            })
        }
        
    }
    
}
