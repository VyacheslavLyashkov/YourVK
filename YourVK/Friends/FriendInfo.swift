//
//  FriendInfo.swift
//  YourVK
//
//  Created by Vyacheslav Lyashkov on 05/10/2018.
//  Copyright © 2018 Vyacheslav Lyashkov. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class FriendInfo: Object {
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var avatar = ""
    @objc dynamic var userID = 0
    let photos = List<Photo>()
    
    convenience init(json: JSON) {
        self.init()
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.avatar = json["photo_200_orig"].stringValue
        self.userID = json["id"].intValue
    }
    
    override static func primaryKey() -> String? {
        return "userID"
    }
}
