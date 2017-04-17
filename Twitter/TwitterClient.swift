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
        
        TwitterClient.sharedInstance!.deauthorize()
        TwitterClient.sharedInstance!.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterclient://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
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
    
    func getUserAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let response = response as! NSDictionary
            let user = User(dictionary: response)
            success(user)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func getHomeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.getAllTweetsFrom(dictionaries: dictionaries)
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func postStatusUpdate(statusText tweetText: String, replyToId: String? = nil, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        let encodedText = tweetText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
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
    
    func unRetweet(tweetId id: Int64, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        post("1.1/statuses/unretweet/\(id).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionary = response as! NSDictionary
            let unRetweetedTweet = Tweet(dictionary: dictionary)
            success(unRetweetedTweet)
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
