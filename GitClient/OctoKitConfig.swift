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

var user:User {
    get{
         var savedUser:User!
        if let data = defaults.objectForKey("userSaved") as? NSData {
            let unarc = NSKeyedUnarchiver(forReadingWithData: data)
            unarc.setClass(User.self, forClassName: "User")
            let user = unarc.decodeObjectForKey("root")
            savedUser = user as! User
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
                // handle any errors
            }
        }

    }

    func getStarredRepos(user:User, config: TokenConfiguration, completion: Result) {
        let name = "GalaevAlexey"
        print(name)
           print(config)
        Octokit(config).stars(name) { response in
            print(response)
            switch response {
            case .Success(let repositories):
                print(repositories)
                 completion(repositories)
                break
            // do something with the repositories
            case .Failure(let error):
                  print(error)
                break
                // handle any errors
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
                // handle any errors
            }
        }
    }
}