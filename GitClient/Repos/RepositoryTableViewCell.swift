//
//  RepositoryTableViewCell.swift
//  GitClient
//
//  Created by Alexey Galaev on 24/03/16.
//  Copyright © 2016 Alexey Galaev. All rights reserved.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setRepository(rep:Repository){
        self.textLabel?.text = rep.fullName
    }

}
