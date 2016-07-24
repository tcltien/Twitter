//
//  LoginViewController.swift
//  Twitter
//
//  Created by Le Huynh Anh Tien on 7/20/16.
//  Copyright © 2016 Tien Le. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func loginAction(sender: AnyObject) {
        
        let client = TwitterClient.shareInstance
        client.login({ () -> () in
            print("I logged in")
            self.performSegueWithIdentifier("loginSegue", sender: nil)
            
        }) { (error: NSError) -> ()  in
                print(error.localizedDescription)
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
