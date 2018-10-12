//
//  RepositoryTableViewCell.swift
//  SystemTest
//
//  Created by sanjay on 10/11/18.
//  Copyright © 2018 Aruna. All rights reserved.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {

    @IBOutlet weak var repoImg: UIImageView!
    @IBOutlet weak var repoLbl: UILabel!
    @IBOutlet weak var repoWatcherCount: UILabel!
    @IBOutlet weak var repoFullNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
