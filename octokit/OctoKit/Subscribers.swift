//
//  Subscribers.swift
//  GitClient
//
//  Created by Alexey Galaev on 01/04/16.
//  Copyright © 2016 Alexey Galaev. All rights reserved.
//


import Foundation
import RequestKit

@objc public class Subscriber: NSObject {

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

    public func subscriber(owner: String? = nil,
                           repo: String? = nil,
                           completion: (response: Response<[Subscriber]>) -> Void) {

        let router = SubscriberRouter.ReadSubscribers(configuration,owner!,repo!)

        router.loadJSON([[String: AnyObject]].self) { json, error in

            if let error = error {
                completion(response: Response.Failure(error))
            }

            if let json = json {
                let repos = json.map{Subscriber(json: $0)}
                completion(response: Response.Success(repos))
            }
        }
    }

    public func subscriber(owner: String, name: String, completion: (response: Response<Subscriber>) -> Void) {
        let router = SubscriberRouter.ReadSubscribers(configuration, owner, name)
        router.loadJSON([String: AnyObject].self) { json, error in
            if let error = error {
                completion(response: Response.Failure(error))
            } else {
                if let json = json {
                    let repo = Subscriber(json: json)
                    completion(response: Response.Success(repo))
                }
            }
        }
    }
}

// MARK: Router

enum SubscriberRouter: Router {

    case ReadSubscribers(Configuration, String, String)

    var configuration: Configuration {
        switch self {
        case .ReadSubscribers(let config, _, _): return config
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
        case .ReadSubscribers:
            return [:]
        }
    }

    var path: String {
        switch self {
        case ReadSubscribers(_, let owner, let rep):
            return "/repos/\(owner)/\(rep)/subscribers"
        }
    }
}

