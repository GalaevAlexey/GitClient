//
//  RepoDetailViewController.swift
//  GitClient
//
//  Created by Alexey Galaev on 25/03/16.
//  Copyright © 2016 Alexey Galaev. All rights reserved.
//

import UIKit

class RepoDetailViewController: UITableViewController {

    var repo:[RepoDetailModel] = []
    var repository:[Repository] = [] {
        didSet {
            updateUI()
        }
    }
    var commits:[Commit] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }


    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var repoDescription: UILabel!
    @IBOutlet weak var watches: UILabel!
    @IBOutlet weak var forkes: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 98
        updateUI()
        loadData()
    }

    func updateUI() {
        self.authorName.text = repository.first?.owner.name
        //self.watches.text =

    }

    func loadData() {

           if let loadedUser = user {

            manager.getForks(config, owner: loadedUser, repo: repository.first!) { completion in
                self.forkes.text = "Forkes: \(completion.count)"
            }

            manager.getCommits(config, owner: loadedUser, repo: repository.first!) { completion in
                self.commits = completion as! [Commit]
            }
        }

////Load Generated repo
//        self.authorName.text = repo.first?.name
//        self.forkes.text = String(repo.first?.forks)
//        self.repoDescription.text = repo.first?.descr
//        self.watches.text = String(repo.first?.watches)
////Commit model Generate
//        for _ in 0 ... 100 {
//            let  unit = RepoCommitModel()
//            commits.append(unit)
//        }



}

/*
//        switch tab {
//        case Repositories.Autorised.hashValue:
//            manager.getRepos(config) { completion in
//                if let repos = completion as? [Repository] {
//                    self.repositories = repos
//                }
//            }
//
//            break
//        case Repositories.Starred.hashValue:
//            if let loadedUser = user {
//                manager.getStarredRepos(loadedUser,config: config) { completion in
//                    if let repos = completion as? [Repository] {
//                        self.repositories = repos
//                    }
//                }
//            }
//            break
//        default:
//            break
*/

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

     override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commits.count
    }

     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("RepoDetailsCell", forIndexPath: indexPath) as! RepoDetailsTableViewCell
        if !commits.isEmpty {
            cell.setDetails(commits[indexPath.row])
        }
        return cell
    }
}
