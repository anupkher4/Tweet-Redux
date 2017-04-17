//
//  User.swift
//  Twitter
//
//  Created by Anup Kher on 4/13/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class User: NSObject {
    static let logoutNotificationName = "userDidLogOut"
    
    var name: String?
    var screenname: String?
    var bio: String?
    var profileUrl: URL?
    private var userJson: NSDictionary?
    
    init(dictionary: NSDictionary) {
        userJson = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        bio = dictionary["description"] as? String
        if let urlString = dictionary["profile_image_url_https"] as? String {
            profileUrl = URL(string: urlString)
        }
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
                let userData = try! JSONSerialization.data(withJSONObject: user.userJson!, options: [])
                defaults.set(userData, forKey: "current_user_data")
            } else {
                defaults.removeObject(forKey: "current_user_data")
            }
            defaults.synchronize()
        }
    }
    
}
