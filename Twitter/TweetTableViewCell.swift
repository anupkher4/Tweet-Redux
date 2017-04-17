//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Anup Kher on 4/14/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit
import AFNetworking

class TweetTableViewCell: UITableViewCell {
    @IBOutlet weak var retweetStackView: UIStackView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!

    var tweet: Tweet! {
        didSet {
            if let user = tweet.user {
                profileImageView.setImageWith(user.profileUrl!)
                nameLabel.text = user.name!
                screennameLabel.text = "@\(user.screenname!)"
            }
            tweetTextLabel.text = tweet.text!
            if let date = tweet.timestamp {
                let now = Date()
                let timeInterval = now.timeIntervalSince(date)
                var calendar = Calendar.current
                calendar.timeZone = TimeZone.current
                let hourComponent = calendar.dateComponents([.hour], from: Date(timeIntervalSinceNow: timeInterval))
                if let hours = hourComponent.hour {
                    if hours > 23 {
                        timeLabel.text = "\(24/hours)d"
                    } else {
                        timeLabel.text = "\(hours)h"
                    }
                }
            }
            if tweet.isRetweeted {
                retweetButton.setImage(UIImage(named: "retweet_on"), for: .normal)
                retweetStackView.isHidden = false
            }
            if tweet.isFavorited {
                likeButton.setImage(UIImage(named: "favorite_on"), for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = 5.0
        profileImageView.clipsToBounds = true
        retweetStackView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func replyClicked(_ sender: UIButton) {
    }
    
    @IBAction func retweetClicked(_ sender: UIButton) {
    }
    
    @IBAction func likeClicked(_ sender: UIButton) {
    }
    
}
