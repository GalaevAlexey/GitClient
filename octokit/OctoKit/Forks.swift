//
//  Forks.swift
//  GitClient
//
//  Created by Alexey Galaev on 30/03/16.
//  Copyright © 2016 Alexey Galaev. All rights reserved.
//

import Foundation
import RequestKit

@objc public class Forks: NSObject {

    public var id: Int?
    public let owner: User
    public init(json: [String: AnyObject]) {
        owner = User(json["owner"] as? [String: AnyObject] ?? [:])
        if let id = json["id"] as? Int {
            self.id = id
        }
    }
}

// MARK: request

public extension Octokit {

    public func forks(owner: String? = nil,
                      repo: String? = nil,
                      completion: (response: Response<[Forks]>) -> Void) {

        let router = ForksRouter.ReadForks(configuration,owner!,repo!)

        router.loadJSON([[String: AnyObject]].self) { json, error in

            if let error = error {
                completion(response: Response.Failure(error))
            }

            if let json = json {
                let repos = json.map{Forks(json: $0)}
                completion(response: Response.Success(repos))
            }
        }
    }

    public func fork(owner: String, name: String, completion: (response: Response<Forks>) -> Void) {
        let router = ForksRouter.ReadForks(configuration, owner, name)
        router.loadJSON([String: AnyObject].self) { json, error in
            if let error = error {
                completion(response: Response.Failure(error))
            } else {
                if let json = json {
                    let repo = Forks(json: json)
                    completion(response: Response.Success(repo))
                }
            }
        }
    }
}

// MARK: Router

enum ForksRouter: Router {

    case ReadForks(Configuration, String, String)

    var configuration: Configuration {
        switch self {
        case .ReadForks(let config, _, _): return config
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
        case .ReadForks:
            return [:]
        }
    }

    var path: String {
        switch self {
        case ReadForks(_, let owner, let rep):
             return "/repos/\(owner)/\(rep)/forks"
        }
    }
}

