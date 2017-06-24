//
//  ProfileViewController2.swift
//  Twitter
//
//  Created by Anup Kher on 6/23/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit
import AFNetworking

class ProfileViewController2: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contenView: UIView!
    @IBOutlet weak var profileBackgroundImageView: UIImageView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var userTweetsTableView: UITableView!
    
    var tweets: [Tweet] = []
    var firstLoad: Bool = true
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
        
        scrollView.delegate = self
        
        userTweetsTableView.delegate = self
        userTweetsTableView.dataSource = self
        userTweetsTableView.estimatedRowHeight = 150.0
        userTweetsTableView.rowHeight = UITableViewAutomaticDimension
        
        let cellNib = UINib(nibName: "TweetNibTableViewCell", bundle: Bundle.main)
        userTweetsTableView.register(cellNib, forCellReuseIdentifier: "ProfileCell2")
        
        user = User.currentUser
        
        profileBackgroundImageView.contentMode = .scaleAspectFill
        profileBackgroundImageView.setImageWith((user?.profileBackgroundUrl)!)
        userProfileImageView.clipsToBounds = true
        userProfileImageView.layer.cornerRadius = 3.0
        userProfileImageView.contentMode = .scaleAspectFill
        userProfileImageView.setImageWith((user?.profileUrl)!)
        tweetsCountLabel.text = "\(user?.tweetsCount ?? 0)"
        followingCountLabel.text = "\(user?.followingCount ?? 0)"
        followersCountLabel.text = "\(user?.followerCount ?? 0)"
        
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
    
    func getTweets() {
        TwitterClient.sharedInstance!.getHomeTimeline(success: { [unowned self] (tweets: [Tweet]) in
            self.tweets = tweets
            self.userTweetsTableView.reloadData()
            self.firstLoad = false
            print("No. of tweets loaded: \(self.tweets.count)")
        }) { (error: Error) in
            print("error: \(error.localizedDescription)")
        }
    }
    
}

extension ProfileViewController2: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("Content size: \(scrollView.contentSize) Offset: \(scrollView.contentOffset)")
    }
    
}

extension ProfileViewController2: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell2", for: indexPath) as! TweetNibTableViewCell
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
}
