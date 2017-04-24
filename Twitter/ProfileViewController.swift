//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Anup Kher on 4/23/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileTableView: UITableView!
    
    var tweets: [Tweet] = []
    var firstLoad: Bool = true
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = UIColor(red: 29/255.0, green: 161/255.0, blue: 242/255.0, alpha: 1.0)
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationItem.title = "\(User.currentUser!.name!)"
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.estimatedRowHeight = 150
        profileTableView.rowHeight = UITableViewAutomaticDimension
        
        let cellNib = UINib(nibName: "TweetNibTableViewCell", bundle: Bundle.main)
        profileTableView.register(cellNib, forCellReuseIdentifier: "ProfileTweetCell")
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
            self.profileTableView.reloadData()
            self.firstLoad = false
            print("No. of tweets loaded: \(self.tweets.count)")
        }) { (error: Error) in
            print("error: \(error.localizedDescription)")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return tweets.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderCell", for: indexPath) as! ProfileHeaderTableViewCell
            if let selectedUser = user {
                cell.user = selectedUser
            } else {
                cell.user = User.currentUser!
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTweetCell", for: indexPath) as! TweetNibTableViewCell
            cell.tweet = tweets[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
