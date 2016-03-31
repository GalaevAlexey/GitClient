//
//  OctoKitConfig.swift
//  GitClient
//
//  Created by Alexey Galaev on 24/03/16.
//  Copyright © 2016 Alexey Galaev. All rights reserved.
//

import Foundation

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

var user:User? {
get{
    var savedUser:User?
    if let data = defaults.objectForKey("userSaved") as? NSData {
        let unarc = NSKeyedUnarchiver(forReadingWithData: data)
        unarc.setClass(User.self, forClassName: "User")
        let user = unarc.decodeObjectForKey("root")
        savedUser = user as? User
    }
    return savedUser
}
}

let config = TokenConfiguration(token)

struct NetworkManager {

    func loadCurrentUser(config: TokenConfiguration) {
        Octokit(config).me() { response in
            switch response {
            case .Success(let user):
                defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(user), forKey: "userSaved")
                defaults.synchronize()
            case .Failure(let error):
                print(error)
            }
        }
    }

    func getRepos(config: TokenConfiguration, completion: Result) {
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

    func getStarredRepos(user:User, config: TokenConfiguration, completion: Result) {
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

    func getUser(config: TokenConfiguration) {
        Octokit(config).me() { response in
            switch response {
            case .Success(let user):
                print(user)
                break
            case .Failure(let error):
                print(error)
                break
            }
        }
    }

    func getForks(config:TokenConfiguration, owner:User,repo:Repository, completion:Result) {
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

    func getCommits(config:TokenConfiguration, owner:User,repo:Repository, completion:Result) {
        let owner = owner.login!
        let repo = repo.name!
        Octokit(config).commits(owner, repo: repo, completion: { responce in
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