//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by Le Huynh Anh Tien on 7/24/16.
//  Copyright © 2016 Tien Le. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var awataImage: UIImageView!
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var textViewEditor: UITextView!
    var countCha = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = User.currentUser
        if let user = user {
            nameLabel.text = user.name as? String
            screennameLabel.text = ("@\(user.screen_name!)")
            awataImage.setImageWithURL(user.profile_url!)
        } else {
            let client = TwitterClient.shareInstance
            client.login({ () -> () in
                print("I logged in")
                self.performSegueWithIdentifier("loginSegue", sender: nil)
                
            }) { (error: NSError) -> ()  in
                print(error.localizedDescription)
            }

        }
        
        textViewEditor.becomeFirstResponder()
        textViewEditor.delegate = self
        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        
        if textView.text == ""  {
            return true
        } else {
            if text != ""  && countCha  < 1 {
                return false
            } else {
                let textViewCha = textView.text as String
                countCha = textViewCha.characters.count - 1
                
            }
        }
        return true
    }
    func textViewDidChange(textView: UITextView) {
        let text = textViewEditor.text as String
        countCha =  140 - text.characters.count
        if countCha == 0 {
            keyLabel.text = "Limited"
            keyLabel.textColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.9)
        } else {
            keyLabel.text = String(countCha)
            keyLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.9)
        }
        
    }
    @IBAction func onTweetClick(sender: AnyObject) {
        let status = textViewEditor.text as String
        if (status != "") {
            TwitterClient.shareInstance.postNewTweet({ (tweet: Tweet) in
            self.performSegueWithIdentifier("newTweetBackTwitterViewController", sender: sender)
            }, failure: { (error: NSError) in
                    print(error.localizedDescription)
            }, status: status)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
