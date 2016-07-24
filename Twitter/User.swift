//
//  User.swift
//  Twitter
//
//  Created by Le Huynh Anh Tien on 7/20/16.
//  Copyright © 2016 Tien Le. All rights reserved.
//

import UIKit

class User: NSObject {

    var name: NSString?
    var screen_name: NSString?
    var profile_url: NSURL?
    var tag_line: NSString?
    var dictionary: NSDictionary?
    
    static let logoutString = "UserDidLogout"
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screen_name = dictionary["screen_name"] as? String
        let profile_urlString  = dictionary["profile_image_url_https"] as? String
        if let profile_urlString = profile_urlString {
            profile_url  = NSURL(string: profile_urlString)
        }
        tag_line = dictionary["description"] as? String
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                
                let userData = defaults.objectForKey("currentUserData") as? NSData
                if  let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }

            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            let defaults = NSUserDefaults.standardUserDefaults()
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                defaults.setObject(data, forKey: "currentUserData")
            } else {
                defaults.setObject(nil, forKey: "currentUserData")
            }
            defaults.synchronize()
            
            
        }
    }
    
}
