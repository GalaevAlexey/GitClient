//
//  ReposViewController.swift
//  Github
//
//  Created by Austin Cherry on 9/28/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//

import UIKit

enum Repositories:Int {
    case    Autorised = 0,
            Starred
}

class ReposViewController: UITableViewController {

    var repositories:[Repository] = [] {
        didSet {
            if repositories.count > 0 {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
         manager.loadCurrentUser(config)
    }

    override func viewWillAppear(animated: Bool) {
    
        let tab = self.tabBarController!.selectedIndex
        print(tab)
        switch tab {
        case Repositories.Autorised.hashValue:
            manager.getRepos(config) { completion in
                if let repos = completion as? [Repository] {
                    self.repositories = repos
                }
            }
            break
        case Repositories.Starred.hashValue:

            manager.getStarredRepos(user,config: config) { completion in
                if let repos = completion as? [Repository] {
                    self.repositories = repos
                }
            }

            break
        default:
            break
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RepoCell", forIndexPath: indexPath) as! RepositoryTableViewCell
        cell.setRepository(repositories[indexPath.row])
        return cell
    }



}
