//
//  TwitterClient.swift
//  Twitter
//
//  Created by Anup Kher on 4/13/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com/")!, consumerKey: "knBaDrzuNwF2FlZgMhjlJaFhn", consumerSecret: "9JHGTEJ8hGAzqW9YSTOxz9Ml3lHPXx5bo5ad6KKVxpn4KDEABB")
    
    private var loginSuccess: (() -> ())?
    private var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterclient://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            let authorizeUrl = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")!
            UIApplication.shared.open(authorizeUrl)
        }, failure: { (error: Error!) -> Void in
            self.loginFailure?(error)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.logoutNotificationName), object: nil)
    }
    
    func handleOpenUrl(url: URL) {
        fetchAccessToken(withPath: "oauth/access_token", method: "GET", requestToken: BDBOAuth1Credential(queryString: url.query!), success: { (accessToken: BDBOAuth1Credential!) in
            
            self.getUserAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
        }, failure: { (error: Error!) in
            self.loginFailure?(error)
        })
    }
    
    private func getUserAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let response = response as! NSDictionary
            let user = User(dictionary: response)
            success(user)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func getHomeTimeline(tweetCount count: Int = 20, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        let params = ["count" : count]
        get("1.1/statuses/home_timeline.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.getAllTweetsFrom(dictionaries: dictionaries)
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func getUserTimeLine(userName name: String, count: Int, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        let params: [String : Any] = [
            "screen_name" : name,
            "count" : count
        ]
        get("1.1/statuses/user_timeline.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.getAllTweetsFrom(dictionaries: dictionaries)
            success(tweets)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func getMentionsTimeline(tweetCount count: Int = 20, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        let params = ["count" : count]
        get("1.1/statuses/mentions_timeline.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.getAllTweetsFrom(dictionaries: dictionaries)
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func postStatusUpdate(statusText tweetText: String, replyToId: String? = nil, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        let encodedText = String(tweetText.utf8)
        print("Tweet: \(encodedText!)")
        var params: [String : AnyObject] = ["status" : encodedText! as AnyObject]
        if let replyId = replyToId {
            params["in_reply_to_status_id"] = replyId as AnyObject
        }
        post("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionary = response as! NSDictionary
            let createdTweet = Tweet(dictionary: dictionary)
            success(createdTweet)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func retweet(tweetId id: Int64, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        post("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionary = response as! NSDictionary
            let retweetedTweet = Tweet(dictionary: dictionary)
            success(retweetedTweet)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
//    func unRetweet(tweetId id: Int64, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
//        post("1.1/statuses/unretweet/\(id).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
//            let dictionary = response as! NSDictionary
//            let unRetweetedTweet = Tweet(dictionary: dictionary)
//            success(unRetweetedTweet)
//        }) { (task: URLSessionDataTask?, error: Error) in
//            failure(error)
//        }
//    }
    
    func unRetweet(tweet: Tweet, success: @escaping (Tweet?) -> (), failure: @escaping (Error) -> ()) {
        var originalTweetId = ""
        if !tweet.isRetweeted {
            // Return, cannot unretweet a tweet which was never retweeted
            success(nil)
        } else {
            if let retweetStatus = tweet.retweetDetails {
                // Tweet was itself a retweet
                originalTweetId = String(retweetStatus.id)
            } else {
                originalTweetId = String(tweet.id)
            }
        }
        let params = ["include_my_retweet" : 1]
        get("1.1/statuses/show/\(originalTweetId).json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionary = response as! NSDictionary
            if let retweetNode = dictionary.object(forKey: "current_user_retweet") as? NSDictionary  {
                if let retweetId = retweetNode.object(forKey: "id_str") as? String {
                    
                    self.post("1.1/statuses/destroy/\(retweetId).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
                        let dict = response as! NSDictionary
                        let deletedRetweet = Tweet(dictionary: dict)
                        success(deletedRetweet)
                    }, failure: { (task: URLSessionDataTask?, error: Error) in
                        failure(error)
                    })
                } else {
                    success(nil)
                }
                
            } else {
                success(nil)
            }
            
            
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func favorite(tweetId id: Int64, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        let params = ["id" : "\(id)"]
        post("1.1/favorites/create.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionary = response as! NSDictionary
            let favoritedTweet = Tweet(dictionary: dictionary)
            success(favoritedTweet)
        }) { (task: URLSessionDataTask?, error:
            Error) in
            failure(error)
        }
    }
    
    func unFavorite(tweetId id: Int64, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        let params = ["id" : "\(id)"]
        post("1.1/favorites/destroy.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionary = response as! NSDictionary
            let unFavoritedTweet = Tweet(dictionary: dictionary)
            success(unFavoritedTweet)
        }) { (task: URLSessionDataTask?, error:
            Error) in
            failure(error)
        }
    }
}
