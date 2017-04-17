//
//  RetweetTableViewCell.swift
//  Twitter
//
//  Created by Anup Kher on 4/16/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class RetweetTableViewCell: UITableViewCell {
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!

    var tweet: Tweet! {
        didSet {
            if tweet.isRetweeted {
                retweetButton.setImage(UIImage(named: "retweet_on"), for: .normal)
            }
            if tweet.isFavorited {
                favoriteButton.setImage(UIImage(named: "favorite_on"), for: .normal)
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

    @IBAction func replyClicked(_ sender: UIButton) {
    }
    @IBAction func retweetClicked(_ sender: UIButton) {
    }
    @IBAction func favoriteClicked(_ sender: UIButton) {
    }
}
