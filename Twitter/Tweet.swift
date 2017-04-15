//
//  Tweet.swift
//  Twitter
//
//  Created by Anup Kher on 4/13/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: String?
    var timestamp: Date?
    var retweets: Int = 0
    var favorites: Int = 0
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        if let createdAt = dictionary["created_at"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
            timestamp = formatter.date(from: createdAt)
        }
        retweets = dictionary["retweet_count"] as? Int ?? 0
        favorites = dictionary["favourites_count"] as? Int ?? 0
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
