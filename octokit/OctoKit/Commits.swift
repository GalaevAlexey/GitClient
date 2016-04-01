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
    }
}

// MARK: request

public extension Octokit {

    public func commits(owner: String? = nil,
                        repo: String? = nil,
                        page: String? = "1",
                        perPage: String? = "15",
                        completion: (response: Response<[Commit]>) -> Void) {

        let router = CommitsRouter.ReadCommits(configuration, owner!, repo!, page!, perPage!)

        router.loadJSON([[String: AnyObject]].self) { json, error in

            if let error = error {
                completion(response: Response.Failure(error))
            }

            if let json = json {
                
                let commits = json.map{Commit(json:$0)}
                completion(response: Response.Success(commits))
            }
        }
    }
}

// MARK: Router

enum CommitsRouter: Router {

    case ReadCommits(Configuration, String, String, String, String)

    var configuration: Configuration {
        switch self {
        case .ReadCommits(let config, _, _, _, _): return config
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
        case .ReadCommits(_, _, _, let page, let perPage):
            print(["per_page": perPage, "page": page])
            return ["per_page": perPage, "page": page]
        }
    }

    var path: String {
        switch self {
        case ReadCommits(_, let owner, let rep,_ ,_ ):
            print("/repos/\(owner)/\(rep)/commits")
            return "/repos/\(owner)/\(rep)/commits"
        }
    }
}

