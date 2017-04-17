//
//  TweetDetailTableViewCell.swift
//  Twitter
//
//  Created by Anup Kher on 4/16/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class TweetDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var retweetStackView: UIStackView!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!

    var tweet: Tweet! {
        didSet {
            if let user = tweet.user {
                profileImageView.setImageWith(user.profileUrl!)
                nameLabel.text = user.name!
                screennameLabel.text = "@\(user.screenname!)"
            }
            tweetTextLabel.text = tweet.text!
            if let date = tweet.timestamp {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "M/dd/yy hh:mm aa"
                let formattedDate = dateFormatter.string(from: date)
                timestampLabel.text = formattedDate
            }
            if tweet.isRetweeted {
                retweetStackView.isHidden = false
                retweetLabel.text = "\(User.currentUser!.screenname!) retweeted"
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

}
