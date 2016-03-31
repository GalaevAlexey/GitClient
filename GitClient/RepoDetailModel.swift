//
//  RepoDetailModel.swift
//  GitClient
//
//  Created by Alexey Galaev on 27/03/16.
//  Copyright © 2016 Alexey Galaev. All rights reserved.
//

import UIKit

struct RepoDetailModel  {

    var name:String?
    var descr:String?
    var watches:Int?
    var forks:Int?

    init (name:String?, description:String?, watches:Int?, forks:Int?, date:NSDate?) {
        self.name = name
        self.descr = description
        self.watches = watches
        self.forks = forks

    }

    init () {
        self.name = "Olloooe"
        self.descr = "Icwienwneoicnowinevnwenvoiw"
        self.watches = 34093
        self.forks = 2323
    }
}
