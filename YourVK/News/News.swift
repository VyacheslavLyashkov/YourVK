//
//  News.swift
//  YourVK
//
//  Created by Vyacheslav Lyashkov on 16/02/2019.
//  Copyright © 2019 Vyacheslav Lyashkov. All rights reserved.
//

import Foundation
import SwiftyJSON

class News {
    
    var name = ""
    var avatar = ""
    var profiles: NewsProfiles?
    var groups: NewsGroups?
    @objc dynamic var type = ""
    @objc dynamic var postID = 0
    @objc dynamic var sourceID = 0
    @objc dynamic var photo = ""
    @objc dynamic var text = ""
    @objc dynamic var likes = 0
    @objc dynamic var comments = 0
    @objc dynamic var reposts = 0
    @objc dynamic var views = 0
    
    
    convenience init(json: JSON) {
        self.init()
        self.type = json["type"].stringValue
        self.postID = json["post_id"].intValue
        self.sourceID = json["source_id"].intValue
        self.photo = json["attachments"][0]["photo"]["photo_604"].stringValue
        self.text = json["text"].stringValue
        self.likes = json["likes"]["count"].intValue
        self.comments = json["comments"]["count"].intValue
        self.reposts = json["reposts"]["count"].intValue
        self.views = json["views"]["count"].intValue
    }
}

class NewsProfiles {
    @objc dynamic var userID = 0
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var avatar = ""
    
    
    
    convenience init(json: JSON) {
        self.init()
        self.userID = json["id"].intValue
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.avatar = json["photo_50"].stringValue
    }
}

class NewsGroups {
    @objc dynamic var groupID = 0
    @objc dynamic var name = ""
    @objc dynamic var avatar = ""
    
    
    
    convenience init(json: JSON) {
        self.init()
        self.groupID = json["id"].intValue
        self.name = json["name"].stringValue
        self.avatar = json["photo_50"].stringValue
    }
}
