//
//  NewGroupsSearch.swift
//  YourVK
//
//  Created by Vyacheslav Lyashkov on 05/10/2018.
//  Copyright © 2018 Vyacheslav Lyashkov. All rights reserved.
//

import Foundation
import SwiftyJSON

class NewGroupsSearch {
    @objc dynamic var groupId = 0
    @objc dynamic var groupName = ""
    @objc dynamic var groupAvatar = ""
    
    convenience init(json: JSON) {
        self.init()
        self.groupId = json["id"].intValue
        self.groupName = json["name"].stringValue
        self.groupAvatar = json["photo_100"].stringValue
    }
}
