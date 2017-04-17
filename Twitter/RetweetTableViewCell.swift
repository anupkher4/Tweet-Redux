//
//  RetweetTableViewCell.swift
//  Twitter
//
//  Created by Anup Kher on 4/16/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

@objc protocol RetweetCellDelegate {
    @objc optional func userDidRetweet(tweet: Tweet)
    @objc optional func userDidFavorite(tweet: Tweet)
}

class RetweetTableViewCell: UITableViewCell {
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!

    let client = TwitterClient.sharedInstance!
    weak var delegate: RetweetCellDelegate?
    
    var tweet: Tweet! {
        didSet {
            print("received id: \(tweet.id)")
            if tweet.isRetweeted {
                retweetButton.setImage(UIImage(named: "retweet_on"), for: .normal)
            } else {
                retweetButton.setImage(UIImage(named: "retweet"), for: .normal)
            }
            if tweet.isFavorited {
                favoriteButton.setImage(UIImage(named: "favorite_on"), for: .normal)
            } else {
                favoriteButton.setImage(UIImage(named: "favorite"), for: .normal)
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
        let id = tweet.id
        client.retweet(tweetId: id, success: { (responseTweet: Tweet) in
            let retweetDetails = responseTweet.retweetDetails!
            self.delegate?.userDidRetweet?(tweet: retweetDetails)
        }) { (error: Error) in
            print("error: \(error.localizedDescription)")
        }
    }
    @IBAction func favoriteClicked(_ sender: UIButton) {
        let id = tweet.id
        if tweet.isFavorited {
            client.unFavorite(tweetId: id, success: { (responseTweet: Tweet) in
                self.delegate?.userDidFavorite?(tweet: responseTweet)
            }) { (error: Error) in
                print("error: \(error.localizedDescription)")
            }
        } else {
            client.favorite(tweetId: id, success: { (responseTweet: Tweet) in
                self.delegate?.userDidFavorite?(tweet: responseTweet)
            }) { (error: Error) in
                print("error: \(error.localizedDescription)")
            }
        }
    }
}
