//
//  SessionManager.swift
//  YourVK
//
//  Created by Vyacheslav Lyashkov on 29.09.2018.
//  Copyright © 2018 Vyacheslav Lyashkov. All rights reserved.
//

import Foundation


class SessionManager {
    private init(){}
    
    static let instance = SessionManager()
    
    var token = ""
    var userid = 0
}
