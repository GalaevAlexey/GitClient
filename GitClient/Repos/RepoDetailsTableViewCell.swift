//
//  RepoDetailsTableViewCell.swift
//  GitClient
//
//  Created by Alexey Galaev on 27/03/16.
//  Copyright © 2016 Alexey Galaev. All rights reserved.
//

import UIKit

class RepoDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var repoHash: UILabel!
    @IBOutlet weak var commitMessage: UILabel!
    let inputDateFormatter = NSDateFormatter()
    let outputDateFormatter = NSDateFormatter()
    override func awakeFromNib() {
        super.awakeFromNib()
        inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        outputDateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func setDetails(item:Commit) {

        author.text = item.author
        let formatted = inputDateFormatter.dateFromString(item.date!)
        let stringDate = outputDateFormatter.stringFromDate(formatted!)
        date.text = stringDate
        repoHash.text = item.repoHash
        commitMessage.text = item.commit
    }
    
}
