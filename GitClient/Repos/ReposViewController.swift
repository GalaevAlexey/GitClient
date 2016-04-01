//
//  ReposViewController.swift
//  GitClient
//
//  Created by Alexey Galaev on 24/03/16.
//  Copyright © 2016 Alexey Galaev. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

enum Repositories:Int {
    case    Autorised = 0,
    Starred
}

let activity:NVActivityIndicatorView  = {
    let screen = UIScreen.mainScreen().bounds
    let size = CGSize(width: 100, height: 100)
    let center = CGPointMake(CGRectGetMidX(screen), CGRectGetMidY(screen))
    let frame = CGRect(origin: CGPointMake(CGRectGetMidX(screen), CGRectGetMidY(screen)), size: size)
    let a = NVActivityIndicatorView(frame: frame,
                                    color: UIColor.greenColor(),
                                    size: size)
    a.hidesWhenStopped = true
    a.center = center
    return a
}()


class ReposViewController: UITableViewController, UITabBarDelegate{

    var tab:Int = 0

    var repositories:[Repository] = [] {
        didSet {
            activity.stopAnimation()
            if repositories.count > 0 {
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

    var isDataLoading = false {
        didSet {
            if isDataLoading {
                activity.startAnimation()
            } else {
                activity.stopAnimation()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setActivity()
    }

    func setActivity(){
        self.tabBarController?.view.addSubview(activity)
        self.navigationItem.title = "Loading Data From Git"
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        tab = self.tabBarController!.selectedIndex
        loadData()
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
    }

    func loadData(){
        isDataLoading = true
        switch tab {
        case Repositories.Autorised.hashValue:
            manager.getRepos() {[unowned self] completion in
                dispatch_async(dispatch_get_main_queue()) {[unowned self] in
                    if let repos = completion as? [Repository] {
                        self.repositories = repos
                        self.isDataLoading = false
                    }
                }
            }

            break
        case Repositories.Starred.hashValue:
            manager.getStarredRepos(currentUser.savedUser!) { [unowned self] completion in
                dispatch_async(dispatch_get_main_queue()) {[unowned self] in
                    if let repos = completion as? [Repository] {
                        self.repositories = repos
                        self.isDataLoading = false
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
        vc.hidesBottomBarWhenPushed = true
        if let selectedCell = sender as? RepositoryTableViewCell {
            let index = self.tableView.indexPathForCell(selectedCell)
            print([repositories[index!.row]])
            vc.repository = [repositories[index!.row]]
        }
    }
}
