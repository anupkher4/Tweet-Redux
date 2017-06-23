//
//  MentionsViewController2.swift
//  Twitter
//
//  Created by Anup Kher on 6/23/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class MentionsViewController2: UIViewController {
    @IBOutlet weak var mentionsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        mentionsTableView.delegate = self
        mentionsTableView.dataSource = self
        mentionsTableView.estimatedRowHeight = 100.0
        mentionsTableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension MentionsViewController2: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MentionsCell2", for: indexPath) as! MentionsTableViewCell
        
        cell.nameLabel.text = "Section \(indexPath.section)"
        cell.screennameLabel.text = "Row \(indexPath.row)"
        
        return cell
    }
    
}
