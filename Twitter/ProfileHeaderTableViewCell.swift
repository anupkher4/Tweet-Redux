//
//  ProfileHeaderTableViewCell.swift
//  Twitter
//
//  Created by Anup Kher on 4/23/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class ProfileHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    
    var user: User! {
        didSet {
            nameLabel.text = user.name!
            screennameLabel.text = user.screenname!
            tweetCountLabel.text = "\(user.tweetsCount!)"
            followerCountLabel.text = "\(user.followerCount!)"
            followingCountLabel.text = "\(user.followingCount!)"
            if let bgUrl = user.profileBackgroundUrl {
                backgroundImageView.setImageWith(bgUrl)
            }
            if let profileUrl = user.profileUrl {
                profileImageView.setImageWith(profileUrl)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
