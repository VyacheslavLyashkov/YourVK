//
//  Photo.swift
//  YourVK
//
//  Created by Vyacheslav Lyashkov on 05/10/2018.
//  Copyright © 2018 Vyacheslav Lyashkov. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Photo: Object {
    @objc dynamic var photoID = 0
    @objc dynamic var photo = ""
    
    convenience init(json: JSON) {
        self.init()
        self.photoID = json["id"].intValue
        self.photo = json["photo_604"].stringValue
    }
    
    override static func primaryKey() -> String? {
        return "photoID"
    }
}
