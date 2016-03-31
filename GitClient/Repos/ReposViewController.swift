//
//  ReposViewController.swift
//  Github
//
//  Created by Austin Cherry on 9/28/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

enum Repositories:Int {
    case    Autorised = 0,
    Starred
}

class ReposViewController: UITableViewController, UITabBarDelegate{

    var repos:[RepoDetailModel] = []
    var tab:Int = 0
    lazy var activity:NVActivityIndicatorView  = {
        let screen = UIScreen.mainScreen().bounds
        let size = CGSize(width: 100, height: 100)
        let center = CGPointMake(CGRectGetMidX(screen), CGRectGetMidY(screen))
        let frame = CGRect(origin: CGPointMake(CGRectGetMidX(screen), CGRectGetMidY(screen)), size: size)
        let a = NVActivityIndicatorView(frame: frame,
                                        type: NVActivityIndicatorType.BallGridPulse,
                                        color: UIColor.greenColor(),
                                        size: size)
        a.hidesWhenStopped = true
        a.center = center
        return a
    }()

    var repositories:[Repository] = [] {
        didSet {
            if repositories.count > 0 {
                activity.stopAnimation()
                self.tableView.reloadData()
                switch tab {
                case Repositories.Autorised.hashValue:
                    self.navigationItem.title = "Autorised"
                    break
                case Repositories.Starred.hashValue:
                    self.navigationItem.title = "Starred"
                    break
                default:
                    break
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setActivity()
        manager.loadCurrentUser(config)
    }

    func setActivity(){
        self.tabBarController?.view.addSubview(activity)
        activity.startAnimation()
        self.navigationItem.title = "Loading Data From Git"
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        tab = self.tabBarController!.selectedIndex
        //repositories = []
        loadData()
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        activity.stopAnimation()
    }

    func loadData(){

        switch tab {
        case Repositories.Autorised.hashValue:
            manager.getRepos(config) { completion in
                if let repos = completion as? [Repository] {
                    self.repositories = repos
                }
            }

            break
        case Repositories.Starred.hashValue:
            if let loadedUser = user {
                manager.getStarredRepos(loadedUser,config: config) { completion in
                    if let repos = completion as? [Repository] {
                        self.repositories = repos
                    }
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
        if !repositories.isEmpty {
            cell.setRepository(repositories[indexPath.row])

        }
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as!
        RepoDetailViewController
        if let selectedCell = sender as? RepositoryTableViewCell {
            let index = self.tableView.indexPathForCell(selectedCell)
            vc.repository = [repositories[index!.row]]
        }
        //Create fake repos
        for i in 0 ..< repositories.count {
            var  unit = RepoDetailModel()
            unit.forks = i
            unit.watches = arc4random().hashValue
            repos.append(unit)
        }
        
        vc.repo = [repos.first!]
    }
}
