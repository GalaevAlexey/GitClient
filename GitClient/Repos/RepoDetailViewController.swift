//
//  RepoDetailViewController.swift
//  GitClient
//
//  Created by Alexey Galaev on 25/03/16.
//  Copyright © 2016 Alexey Galaev. All rights reserved.
//

import UIKit
import ImageLoader

class RepoDetailViewController: UITableViewController, ZoomTransitionProtocol {

    var animationController: ZoomTransition?
    var bigImage: UIImage?
    var repository:[Repository] = []
    var commits:[Commit] = [] {
        didSet {
            self.tableView.reloadData()
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

    var currentPage = 1

    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var repoDescription: UILabel!
    @IBOutlet weak var watches: UILabel!
    @IBOutlet weak var forkes: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 98
        self.tabBarController!.view.addSubview(activity)
        activity.startAnimation()
        setupUI()
        loadData()
    }

    override func viewWillAppear(animated: Bool) {

        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func setupUI(){

        if let navigationController = self.navigationController {
            animationController = ZoomTransition(navigationController: navigationController)
        }
        self.navigationController?.delegate = animationController
        authorImage.userInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RepoDetailViewController.handleTapGesture(_:)))
        authorImage.addGestureRecognizer(tapGesture)
    }

    func updateUI() {

        self.authorName.text = currentUser.loadedUser!.name
        let name = repository.first?.name
        self.repoName.text = name
        self.repoDescription.text = repository.first?.repositoryDescription

        if let URL = repository.first?.owner.avatarURL {
            self.authorImage.load(URL, placeholder: nil) { URL, image, error, cacheType in
                self.bigImage = image
            }
        }
    }

    func loadData() {

        let ownerOfRepo = repository.first!.owner
            manager.getUser(ownerOfRepo) { completion in
                dispatch_async(dispatch_get_main_queue()) {[unowned self] in
                print(completion)
                currentUser.loadedUser = completion.first as? User
                self.updateUI()
                self.updateData()
                self.getCommitsOnCurrentPage()
                }
            }
    }

    func updateData(){

        manager.getForks(currentUser.loadedUser!, repo: repository.first!) { completion in
            dispatch_async(dispatch_get_main_queue()) {[unowned self] in
                self.forkes.text = "Forkes:  \(completion.count)"
            }
        }

        manager.getSubscribers(currentUser.loadedUser!, repo: repository.first!) { completion in
            dispatch_async(dispatch_get_main_queue()) {[unowned self] in
                self.watches.text = "Watches:  \(completion.count)"
            }
        }
    }

    func getCommitsOnCurrentPage(){

            isDataLoading = true

        let comitterUser:User = ((currentUser.loadedUser) != nil) ? currentUser.loadedUser! : CurrentUser().savedUser!

            manager.getCommits(comitterUser, repo: repository.first!, page:String(currentPage)) { completion in
                dispatch_async(dispatch_get_main_queue()) {[unowned self] in
                    self.isDataLoading = false
                    self.commits.appendContentsOf(completion as! [Commit])
                }
        }
    }

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

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

    }

    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if(self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height)) {
            if(!isDataLoading){
                isDataLoading = true
                currentPage = currentPage + 1;
                getCommitsOnCurrentPage()
            }
        }
    }

    func handleTapGesture(gesture: UITapGestureRecognizer){

        let imageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ImageViewController") as! ImageViewController
        imageViewController.image = bigImage
        self.navigationController?.showViewController(imageViewController, sender: self)
    }
    
    func viewForTransition() -> UIView {
        return authorImage
    }
    
}
