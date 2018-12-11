//
//  Groups.swift
//  YourVK
//
//  Created by Vyacheslav Lyashkov on 05/10/2018.
//  Copyright © 2018 Vyacheslav Lyashkov. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Groups: Object {
    @objc dynamic var groupId = 0
    @objc dynamic var groupName = ""
    @objc dynamic var groupAvatar = ""
    
    convenience init(json: JSON) {
        self.init()
        self.groupId = json["id"].intValue
        self.groupName = json["name"].stringValue
        self.groupAvatar = json["photo_100"].stringValue
    }
    override static func primaryKey() -> String? {
        return "groupId"
    }
}

class GroupsLeave {
    @objc dynamic var response = 0
    
    convenience init(json: JSON) {
        self.init()
        self.response = json["response"].intValue
    }
}
