//
//  OctoKitConfig.swift
//  GitClient
//
//  Created by Alexey Galaev on 24/03/16.
//  Copyright © 2016 Alexey Galaev. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

let manager = NetworkManager()

let defaults = NSUserDefaults()

typealias Result = ([AnyObject]) -> Void

var token:String {
get{
    var tok = ""
    if let token = defaults.valueForKey("token") as? String {
        tok = token
    }
    return tok
}
}

 struct CurrentUser {
    var loadedUser:User?
    var savedUser:User?
}


var config = {
    return TokenConfiguration(token)
}()

struct NetworkManager {

    func loadCurrentUser(completion:Result) {
        Octokit(config).me() { response in
            switch response {
            case .Success(let user):
                completion([user])
            case .Failure(let error):
                print(error)
            }
        }
    }

    func getRepos(completion: Result) {
        Octokit(config).repositories() { response in
            switch response {
            case .Success(let repository):
                completion(repository)
                break
            case .Failure(let error):
                print(error)
                break
            }
        }
    }

    func getStarredRepos(user:User, completion: Result) {
        let name = user.login!

        Octokit(config).stars(name) { response in
            switch response {
            case .Success(let repositories):
                completion(repositories)
                break
            case .Failure(let error):
                print(error)
                break
            }
        }
    }

    func getUser(user:User,completion:Result) {
        let owner = user.login!
        Octokit(config).user(owner){ response in
            switch response {
            case .Success(let user):
                print(user)
                completion([user])
                break
            case .Failure(let error):
                print(error)
                break
            }
        }
    }

    func getForks(owner:User,repo:Repository, completion:Result) {
        let owner = owner.login!
        let repo = repo.name!
        Octokit(config).forks(owner, repo: repo, completion: { responce in
            switch responce {
            case .Success(let repositories):
                completion(repositories)
                break
            case .Failure(let error):
                print(error)
                break
            }
        })
    }

    func getSubscribers(owner:User,repo:Repository, completion:Result) {
        let owner = owner.login!
        let repo = repo.name!
        Octokit(config).subscriber(owner, repo: repo, completion: { responce in
            switch responce {
            case .Success(let repositories):
                completion(repositories)
                break
            case .Failure(let error):
                print(error)
                break
            }
        })
    }

    func getCommits(owner:User,repo:Repository, page:String, completion:Result) {
        let owner = owner.login!
        let repo = repo.name!
        Octokit(config).commits(owner, repo: repo, page:page, completion: { responce in
            switch responce {
            case .Success(let commits):
                completion(commits)
                break
            case .Failure(let error):
                print(error)
                break
            }
        })
    }
}