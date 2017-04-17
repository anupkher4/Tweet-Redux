//
//  ComposeTweetViewController.swift
//  Twitter
//
//  Created by Anup Kher on 4/16/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

@objc protocol ComposeTweetViewControllerDelegate {
    @objc optional func userDidTweet(tweet: Tweet)
}

class ComposeTweetViewController: UIViewController {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    
    weak var delegate: ComposeTweetViewControllerDelegate?
    
    let twitterClient = TwitterClient.sharedInstance!
    
    var isAReply: Bool = false
    var replyToTweetId: String?
    var replyUserHandle: String?
    var currentUser = User.currentUser

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = UIColor(red: 29/255.0, green: 161/255.0, blue: 242/255.0, alpha: 1.0)
        
        let tweetButton = UIBarButtonItem(title: "Tweet", style: .plain, target: self, action: #selector(tweetClicked(sender:)))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClicked(sender:)))
        let titleWidth = (navigationController?.navigationBar.bounds.size.width)! - (tweetButton.width + cancelButton.width)
        let characterCountLabel = UILabel(frame: CGRect(x: 0, y: 0, width: titleWidth, height: 30))
        characterCountLabel.textAlignment = .right
        characterCountLabel.textColor = UIColor.lightGray
        characterCountLabel.text = "0"
        
        navigationItem.titleView = characterCountLabel
        navigationItem.rightBarButtonItem = tweetButton
        navigationItem.leftBarButtonItem = cancelButton
        
        posterImageView.layer.cornerRadius = 5.0
        posterImageView.clipsToBounds = true
        
        if let user = currentUser {
            if let url = user.profileUrl {
                posterImageView.setImageWith(url)
            }
            nameLabel.text = user.name!
            screennameLabel.text = user.screenname!
        }
        
        tweetTextView.delegate = self
        tweetTextView.becomeFirstResponder()
        
        if isAReply {
            tweetTextView.text = "@\(replyUserHandle!)"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isAReply = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tweetClicked(sender: UIBarButtonItem) {
        // Tweet tweet
        if let tweetText = tweetTextView.text {
            if isAReply {
                if let replyId = replyToTweetId {
                    twitterClient.postStatusUpdate(statusText: tweetText, replyToId: replyId, success: { (responseTweet: Tweet) in
                        self.delegate?.userDidTweet?(tweet: responseTweet)
                        self.dismiss(animated: true, completion: nil)
                    }, failure: { (error: Error) in
                        print("error: \(error.localizedDescription)")
                    })
                }
            } else {
                twitterClient.postStatusUpdate(statusText: tweetText, success: { (responseTweet: Tweet) in
                    self.delegate?.userDidTweet?(tweet: responseTweet)
                    self.dismiss(animated: true, completion: nil)
                }, failure: { (error: Error) in
                    print("error: \(error.localizedDescription)")
                })
            }
        }
    }
    
    func cancelClicked(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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

extension ComposeTweetViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let length = textView.text.characters.count
        let characterLabel = navigationItem.titleView as! UILabel
        characterLabel.text = "\(140 - length)"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.characters.count == 0 {
            if textView.text.characters.count != 0 {
                return true
            }
        } else if textView.text.characters.count > 139 {
            return false
        }
        return true
    }
    
}
