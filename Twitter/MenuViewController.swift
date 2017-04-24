//
//  MenuViewController.swift
//  Twitter
//
//  Created by Anup Kher on 4/22/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var menuTableView: UITableView!
    
    var profileViewController: UIViewController!
    var tweetsViewController: UIViewController!
    var mentionsViewController: UIViewController!
    var accountsViewController: UIViewController!
    
    var viewControllers: [UIViewController] = []
    
    var menuItems: [String] = ["Profile", "Timeline", "Mentions", "Accounts"]
    
    var contentViewController: ContentViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileNavController")
        tweetsViewController = storyboard.instantiateViewController(withIdentifier: "TweetsNavController")
        mentionsViewController = storyboard.instantiateViewController(withIdentifier: "MentionsNavController")
        accountsViewController = storyboard.instantiateViewController(withIdentifier: "AccountsViewController")
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        viewControllers.append(profileViewController)
        viewControllers.append(tweetsViewController)
        viewControllers.append(mentionsViewController)
        viewControllers.append(accountsViewController)
        
        contentViewController.contentViewController = tweetsViewController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuTableViewCell
        cell.menuTextLabel.text = menuItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        contentViewController.contentViewController = viewControllers[indexPath.row]
    }
    
}
