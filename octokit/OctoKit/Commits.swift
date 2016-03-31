//
//  Commits.swift
//  GitClient
//
//  Created by Alexey Galaev on 31/03/16.
//  Copyright © 2016 Alexey Galaev. All rights reserved.
//

//
//  Forks.swift
//  GitClient
//
//  Created by Alexey Galaev on 30/03/16.
//  Copyright © 2016 Alexey Galaev. All rights reserved.
//

import Foundation
import RequestKit

@objc public class Commit: NSObject {


    var author:String?
    var repoHash:String?
    var commit:String?
    var date:String?

    public init(json: [String: AnyObject]) {

        if let author = json["commit"]?["author"]?!["name"] as? String {
            self.author = author
        }
        if let sha = json["sha"] as? String {
            self.repoHash = sha
        }
        if let commit = json["commit"]?["message"] as? String {
            self.commit = commit
        }
        if let date = json["commit"]?["author"]?!["date"] as? String {
            self.date = date
        }


      //  if let author = json["commit"]["author"]["name"] as?
    }
}

// MARK: request

public extension Octokit {

    public func commits(owner: String? = nil,
                      repo: String? = nil,
                      completion: (response: Response<[Commit]>) -> Void) {

        let router = CommitsRouter.ReadCommits(configuration,owner!,repo!)

        router.loadJSON([[String: AnyObject]].self) { json, error in

            if let error = error {
                completion(response: Response.Failure(error))
            }

            if let json = json {
                let commits = json.map{Commit(json: $0)}
                completion(response: Response.Success(commits))
            }
        }
    }

    public func fork(owner: String, name: String, completion: (response: Response<Commit>) -> Void) {
        let router = ForksRouter.ReadForks(configuration, owner, name)
        router.loadJSON([String: AnyObject].self) { json, error in
            if let error = error {
                completion(response: Response.Failure(error))
            } else {
                if let json = json {
                    let commit = Commit(json: json)
                    completion(response: Response.Success(commit))
                }
            }
        }
    }
}

// MARK: Router

enum CommitsRouter: Router {

    case ReadCommits(Configuration, String, String)

    var configuration: Configuration {
        switch self {
        case .ReadCommits(let config, _, _): return config
        }
    }

    var method: HTTPMethod {
        return .GET
    }

    var encoding: HTTPEncoding {
        return .URL
    }

    var params: [String: String] {
        switch self {
        case .ReadCommits:
            return [:]
        }
    }

    var path: String {
        switch self {
        case ReadCommits(_, let owner, let rep):
            return "/repos/\(owner)/\(rep)/commits"
        }
    }
}

