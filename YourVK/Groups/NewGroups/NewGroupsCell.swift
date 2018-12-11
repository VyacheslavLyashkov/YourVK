//
//  NewGroupsCell.swift
//  YourVK
//
//  Created by Vyacheslav Lyashkov on 31.08.2018.
//  Copyright © 2018 Vyacheslav Lyashkov. All rights reserved.
//

import UIKit

class NewGroupsCell: UITableViewCell {
    
    @IBOutlet weak var groupAvatar: UIImageView!
    @IBOutlet weak var newGroupName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
