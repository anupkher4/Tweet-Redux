//
//  User.swift
//  Twitter
//
//  Created by Anup Kher on 4/13/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class User: NSObject, NSCoding {
    static let logoutNotificationName = "userDidLogOut"
    
    var name: String?
    var screenname: String?
    var bio: String?
    var profileUrl: URL?
    var profileBackgroundUrl: URL?
    var tweetsCount: Int?
    var followingCount: Int?
    var followerCount: Int?
    private var userJson: NSDictionary?
    
    init(name: String?, screenname: String?, bio: String?, profileUrl: URL?, profileBackgroundUrl: URL?, tweetsCount: Int?, followingCount: Int?, followerCount: Int?) {
        self.name = name
        self.screenname = screenname
        self.bio = bio
        self.profileUrl = profileUrl
        self.profileBackgroundUrl = profileBackgroundUrl
        self.tweetsCount = tweetsCount
        self.followingCount = followingCount
        self.followerCount = followerCount
    }
    
    init(dictionary: NSDictionary) {
        userJson = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        bio = dictionary["description"] as? String
        if let urlString = dictionary["profile_image_url_https"] as? String {
            profileUrl = URL(string: urlString)
        }
        if let bgUrlString = dictionary["profile_background_image_url_https"] as? String {
            profileBackgroundUrl = URL(string: bgUrlString)
        }
        tweetsCount = dictionary["statuses_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
        followerCount = dictionary["followers_count"] as? Int
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                if let userData = defaults.object(forKey: "current_user_data") as? Data {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: [JSONSerialization.ReadingOptions.allowFragments]) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            let defaults = UserDefaults.standard
            if let user = user {
                userAccounts[user.screenname!] = user
                let userData = try! JSONSerialization.data(withJSONObject: user.userJson!, options: [])
                defaults.set(userData, forKey: "current_user_data")
            } else {
                defaults.removeObject(forKey: "current_user_data")
            }
            defaults.synchronize()
        }
    }
    
    static var userAccounts: [String : User] = [:]
    
    
    // MARK: - NSCoding
    
    private struct PropertyKey {
        static let name = "UserName"
        static let screennmae = "UserScreenName"
        static let bio = "UserBio"
        static let profileUrl = "UserProfileUrl"
        static let profileBackgroundUrl = "UserProfileBackgroundUrl"
        static let tweetsCount = "UserTweetsCount"
        static let followingCount = "UserFollowingCount"
        static let followerCount = "UserFolowerCount"
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String
        let screenname = aDecoder.decodeObject(forKey: PropertyKey.screennmae) as? String
        let bio = aDecoder.decodeObject(forKey: PropertyKey.bio) as? String
        let profileUrl = aDecoder.decodeObject(forKey: PropertyKey.profileUrl) as? URL
        let profileBackgroundUrl = aDecoder.decodeObject(forKey: PropertyKey.profileBackgroundUrl) as? URL
        let tweetsCount = aDecoder.decodeObject(forKey: PropertyKey.tweetsCount) as? Int
        let followingCount = aDecoder.decodeObject(forKey: PropertyKey.followingCount) as? Int
        let followerCount = aDecoder.decodeObject(forKey: PropertyKey.followerCount) as? Int
        
        self.init(name: name, screenname: screenname, bio: bio, profileUrl: profileUrl, profileBackgroundUrl: profileBackgroundUrl, tweetsCount: tweetsCount, followingCount: followingCount, followerCount: followerCount)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: PropertyKey.name)
        aCoder.encode(self.screenname, forKey: PropertyKey.screennmae)
        aCoder.encode(self.bio, forKey: PropertyKey.bio)
        aCoder.encode(self.profileUrl, forKey: PropertyKey.profileUrl)
        aCoder.encode(self.profileBackgroundUrl, forKey: PropertyKey.profileBackgroundUrl)
        aCoder.encode(self.tweetsCount, forKey: PropertyKey.tweetsCount)
        aCoder.encode(self.followingCount, forKey: PropertyKey.followingCount)
        aCoder.encode(self.followerCount, forKey: PropertyKey.followerCount)
    }

    
}
