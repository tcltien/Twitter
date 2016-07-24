//
//  TwitterClient.swift
//  Twitter
//
//  Created by Le Huynh Anh Tien on 7/22/16.
//  Copyright © 2016 Tien Le. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    static let shareInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com"), consumerKey: "AgayZ2gv0P3HO3JGm6Bn6xY7s", consumerSecret: "X36IJMKMKWLWcp4OI8zGBeuo8f98qYP2xepEVTYRaZsUZuX0hz")
    
    var loginSuccess: (() -> ())?
    var loginFailure : ((NSError) -> ())?
    
    func homeTimeLine(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            if let  dictionaries = response as? [NSDictionary] {
                let tweets =  Tweet.tweetsWithArray(dictionaries)
                success(tweets)
            }
            
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
       
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> () ) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("My Account")
            let  userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
            print(user.name)
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            failure(error)
        })

    }
    func postNewTweet(success: (Tweet) -> () , failure: (NSError) -> (), status: String) {
        let parameters: [String : AnyObject] = ["status": status]
        
        POST("1.1/statuses/update.json", parameters: parameters, progress: nil, success: { (task :NSURLSessionDataTask, response: AnyObject?) in
            let tweet = Tweet.init(dictionary: response as! NSDictionary)
            success(tweet)
            
        }) { (task :NSURLSessionDataTask?, error :NSError) in
            failure(error)
        }
    }
    func postFavorite(success: (Tweet) -> () , failure: (NSError) -> (), id: String) {
        let parameters: [String : AnyObject] = ["id": id]
        POST("1.1/favorites/create.json", parameters: parameters, progress: nil, success: { (task :NSURLSessionDataTask, response: AnyObject?) in
            let tweet = Tweet.init(dictionary: response as! NSDictionary)
            success(tweet)
            
        }) { (task :NSURLSessionDataTask?, error :NSError) in
            failure(error)
        }
    }
    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.shareInstance.deauthorize()
        TwitterClient.shareInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterdemo://oauth"), scope: nil, success: { (request_token: BDBOAuth1Credential!) -> Void in
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(request_token.token)")!
            UIApplication.sharedApplication().openURL(url)
            
        }) { (error: NSError!) -> Void in
            print("error\(error.localizedDescription)")
            self.loginFailure?(error)
        }
        
    }
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.logoutString, object: nil)
    }
    
    func handleOpenUrl(url: NSURL) {
        let request_token = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: request_token, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            
            self.currentAccount({ (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: NSError) in
                    self.loginFailure?(error)
            })
            self.loginSuccess?()
            
            
        }) { (error: NSError!) -> Void in
            print(error.localizedDescription)
            self.loginFailure?(error)
        }

    }
}
