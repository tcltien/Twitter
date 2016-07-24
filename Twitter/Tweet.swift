//
//  Tweet.swift
//  Twitter
//
//  Created by Le Huynh Anh Tien on 7/20/16.
//  Copyright © 2016 Tien Le. All rights reserved.
//

import UIKit
import NSDate_TimeAgo

class Tweet: NSObject {
    
    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favouritesCount : Int = 0
    var name: NSString?
    var scrName: NSString?
    var imageUrl: NSURL?
    var media: NSURL?
    var id: String!
    var loca  = NSLocale.currentLocale().localeIdentifier
    init(dictionary: NSDictionary) {
        let user = dictionary["user"]!
        text = dictionary["text"] as? String
        id = dictionary["id_str"] as! String
        if let timestampString = dictionary.valueForKey("created_at") {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = dateFormatter.dateFromString(timestampString as! String)
        }
       
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favouritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        name = user["name"] as? String
        scrName = user["screen_name"] as? String
        
        let imageURLString = user["profile_image_url_https"] as? String
        if imageURLString != nil {
            imageUrl = NSURL(string: imageURLString!)!
        } else {
            imageUrl = NSURL(string: "")
        }
        if let exEntity = dictionary.valueForKey("extended_entities") as? NSDictionary {
            // print(exEntity["media"])
            let mediaObj = exEntity["media"] as? [NSDictionary]
            for mo in mediaObj! {
                //print(mo["media_url"])
                media = NSURL(string: mo["media_url"] as! String)
            }
            
//        } else if let entity = dictionary.valueForKey("entities") {
//            
//            print(dictionary)
//            if let mediaObj = entity["media"] {
//                if mediaObj != nil {
//                    print(mediaObj)
//                    media = NSURL(string: mediaObj!["media_url"] as! String)
//                }
//            }
//
        } else {
            media = nil;
            print("error get media")
        }
        
    }
    
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}
