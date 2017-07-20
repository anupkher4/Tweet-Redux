//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Anup Kher on 4/14/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

@objc protocol TweetTableViewCellDelegate {
    @objc optional func userTappedRetweet(cell: UITableViewCell, currentState: Bool)
    @objc optional func userTappedFavorite(cell: UITableViewCell, currentState: Bool)
    @objc optional func userTappedReply(cell: UITableViewCell)
}


class TweetTableViewCell: UITableViewCell {
    @IBOutlet weak var retweetStackView: UIStackView!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    weak var delegate: TweetTableViewCellDelegate?

    var tweet: Tweet! {
        didSet {
            if let user = tweet.user {
                profileImageView.setImageWith(user.profileUrl!)
                nameLabel.text = user.name!
                screennameLabel.text = "@\(user.screenname!)"
            }
            tweetTextLabel.text = tweet.text!
            if tweet.isRetweeted {
                retweetButton.setImage(UIImage(named: "retweet_on"), for: .normal)
                retweetStackView.isHidden = false
                retweetLabel.text = "\(User.currentUser!.screenname!) retweeted"
            }
            if tweet.isFavorited {
                likeButton.setImage(UIImage(named: "favorite_on"), for: .normal)
            }
            if let date = tweet.timestamp {
                let now = Date()
                let timeInterval = now.timeIntervalSince(date)
                var calendar = Calendar.current
                calendar.timeZone = TimeZone.current
                let minuteComponent = calendar.dateComponents([.minute], from: Date(timeIntervalSinceNow: timeInterval))
                let hourComponent = calendar.dateComponents([.hour], from: Date(timeIntervalSinceNow: timeInterval))
                let dayComponent = calendar.dateComponents([.day], from: Date(timeIntervalSinceNow: timeInterval))
                guard let minutes = minuteComponent.minute, let hours = hourComponent.hour, let days = dayComponent.day else {
                    return
                }
                if minutes <= 59 {
                    timeLabel.text = "\(minutes)m"
                } else if hours <= 23 {
                    timeLabel.text = "\(hours)h"
                } else {
                    timeLabel.text = "\(days)d"
                }
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
        delegate?.userTappedReply?(cell: self)
    }
    
    @IBAction func retweetClicked(_ sender: UIButton) {
        let state = toggleRetweetImage()
        delegate?.userTappedRetweet?(cell: self, currentState: state)
    }
    
    @IBAction func likeClicked(_ sender: UIButton) {
        let state = toggleFavoriteImage()
        delegate?.userTappedFavorite?(cell: self, currentState: state)
    }
    
    //MARK: - Helper functions
    
    private func toggleRetweetImage() -> Bool {
        var state = false
        
        if retweetButton.image(for: .normal) == UIImage(named: "retweet_on") {
            retweetButton.setImage(UIImage(named: "retweet"), for: .normal)
            state = false
        } else {
            retweetButton.setImage(UIImage(named: "retweet_on"), for: .normal)
            state = true
        }
        
        return state
    }
    
    private func toggleFavoriteImage() -> Bool {
        var state = false
        
        if likeButton.image(for: .normal) == UIImage(named: "favorite_on") {
            likeButton.setImage(UIImage(named: "favorite"), for: .normal)
            state = false
        } else {
            likeButton.setImage(UIImage(named: "favorite_on"), for: .normal)
            state = true
        }
        
        return state
    }
    
}
