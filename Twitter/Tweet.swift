//
//  Tweet.swift
//  Twitter
//
//  Created by Anup Kher on 4/13/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var id: Int64
    var text: String?
    var timestamp: Date?
    var retweets: Int = 0
    var favorites: Int = 0
    var isRetweeted: Bool = false
    var isFavorited: Bool = false
    var user: User?
    var retweetDetails: Tweet?
    
    init(dictionary: NSDictionary) {
        let id_str = dictionary["id_str"] as! String
        id = Int64(id_str)!
        text = dictionary["text"] as? String
        if let createdAt = dictionary["created_at"] as? String {
            let formatter = DateFormatter()
            formatter.locale = Locale.current
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
            let createdDate = formatter.date(from: createdAt)
            timestamp = createdDate
        }
        retweets = dictionary["retweet_count"] as? Int ?? 0
        favorites = dictionary["favorite_count"] as? Int ?? 0
        isRetweeted = dictionary["retweeted"] as? Bool ?? false
        isFavorited = dictionary["favorited"] as? Bool ?? false
        if let userDict = dictionary["user"] as? NSDictionary {
            user = User(dictionary: userDict)
        }
        if let retweetDict = dictionary["retweeted_status"] as? NSDictionary {
            retweetDetails = Tweet(dictionary: retweetDict)
        }
    }
    
    class func getAllTweetsFrom(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets: [Tweet] = []
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
}
