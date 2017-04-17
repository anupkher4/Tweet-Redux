//
//  CountTableViewCell.swift
//  Twitter
//
//  Created by Anup Kher on 4/16/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class CountTableViewCell: UITableViewCell {
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!

    var tweet: Tweet! {
        didSet {
            retweetCountLabel.text = "\(tweet.retweets)"
            favoritesCountLabel.text = "\(tweet.favorites)"
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
