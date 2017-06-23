//
//  MentionsViewController.swift
//  Twitter
//
//  Created by Anup Kher on 4/22/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController {
    @IBOutlet weak var mentionsTableView: UITableView!

    var tweets: [Tweet] = []
    var isFirstLoad: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = UIColor(red: 29/255.0, green: 161/255.0, blue: 242/255.0, alpha: 1.0)
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationItem.title = "Mentions"
        
        mentionsTableView.delegate = self
        mentionsTableView.dataSource = self
        mentionsTableView.estimatedRowHeight = 150.0
        mentionsTableView.rowHeight = UITableViewAutomaticDimension
        
        let cellNib = UINib(nibName: "TweetNibTableViewCell", bundle: Bundle.main)
        mentionsTableView.register(cellNib, forCellReuseIdentifier: "MentionsCell")
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: .valueChanged)
        mentionsTableView.insertSubview(refreshControl, at: 0)
        
        getMentions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isFirstLoad {
            getMentions()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutCLicked(_ sender: UIBarButtonItem) {
        TwitterClient.sharedInstance!.logout()
    }
    
    func getMentions(refreshControl: UIRefreshControl? = nil) {
        TwitterClient.sharedInstance!.getMentionsTimeline(success: { [unowned self] (tweets: [Tweet]) in
            self.tweets = tweets
            self.mentionsTableView.reloadData()
            self.isFirstLoad = false
            if let refresh = refreshControl {
                refresh.endRefreshing()
            }
            print("No. of tweets loaded: \(self.tweets.count)")
        }) { (error: Error) in
            print("error: \(error.localizedDescription)")
        }
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        getMentions(refreshControl: refreshControl)
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

extension MentionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MentionsCell", for: indexPath) as! TweetNibTableViewCell
        
        let tweet = tweets[indexPath.row]
        cell.tweet = tweet
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
