//
//  LoginViewController.swift
//  Twitter
//
//  Created by Anup Kher on 4/13/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.cornerRadius = 4.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginClicked(_ sender: UIButton) {
        TwitterClient.sharedInstance!.login(success: { [unowned self] _ in
//            self.performSegue(withIdentifier: "loginToHome", sender: nil)
            let vc = self.appDelegate.superContentViewController!
            self.present(vc, animated: true, completion: nil)
        }) { (error: Error) in
            print("error: \(error.localizedDescription)")
        }
    }

}
