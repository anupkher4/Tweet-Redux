//
//  AccountsViewController.swift
//  Twitter
//
//  Created by Anup Kher on 4/23/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class AccountsViewController: UIViewController {
    @IBOutlet weak var accountsTableView: UITableView!
    
    var accounts: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        accountsTableView.delegate = self
        accountsTableView.dataSource = self
        accountsTableView.estimatedRowHeight = 150
        accountsTableView.rowHeight = UITableViewAutomaticDimension
        
        for (_, element) in User.userAccounts.enumerated() {
            let user = element.value
            accounts.append(user)
        }
        
        accountsTableView.reloadData()
        print("Accounts: \(accounts.count)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension AccountsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountsCell", for: indexPath) as! AccountsTableViewCell
        
        let user = accounts[indexPath.row]
        cell.user = user
        
        return cell
    }
    
}
