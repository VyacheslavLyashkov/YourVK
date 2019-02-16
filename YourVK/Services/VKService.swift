//
//  VKServices.swift
//  YourVK
//
//  Created by Vyacheslav Lyashkov on 06/10/2018.
//  Copyright © 2018 Vyacheslav Lyashkov. All rights reserved.
//

import Alamofire
import Foundation
import RealmSwift
import SwiftyJSON

class VKService {
    
    let baseUrl = "https://api.vk.com/method"
    let vkApiVer = "5.85"
    
    func getFriends() {
        let params: Parameters = [
            "order": "hints",
            "fields": "nickname,photo_200_orig,online",
            "access_token": SessionManager.instance.token,
            "v": vkApiVer
        ]
        let url = baseUrl + "/friends.get"
        
        Alamofire.request(url, method: .get, parameters: params).responseData (queue: DispatchQueue.global()) { repsons in
            guard let data = repsons.value else { return }
            let json = try! JSON(data: data)
            let friends = json["response"]["items"].compactMap { FriendInfo(json: $0.1) }
            self.saveFriendData(friends)
        }
//        let params: Parameters = [
//            "order": "hints",
//            "fields": "nickname,photo_200_orig",
//            "access_token": SessionManager.instance.token,
//            "v": vkApiVer,
//            "count": 20,
//            "offset" : 100
////            Здесь нужно добавить два параметра
////            Документация отсюда https://vk.com/dev/friends.get
////            count количество друзей, которое нужно вернуть.
////            положительное число, по умолчанию 5000
////            offset смещение, необходимое для выборки определенного подмножества друзей.
////            положительное число
//        ]
//        let url = baseUrl + "/friends.get"
//
//        Alamofire.request(url, method: .get, parameters: params).responseData { repsons in
//            guard let data = repsons.value else { return }
//            let json = try! JSON(data: data)
//            let friends = json["response"]["items"].compactMap { FriendInfo(json: $0.1) }
//            completion(friends)
//        }
    }
    
    func saveFriendData(_ friends: [FriendInfo]) {
        do {
            let realm = try Realm()
            print(realm.configuration.fileURL as Any)
            let oldFriends = realm.objects(FriendInfo.self)
            realm.beginWrite()
            realm.delete(oldFriends)
            realm.add(friends, update: true)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func getPhotos(userID: Int) {
        let params: Parameters = [
            "owner_id": userID,
            "album_id": "profile",
            "access_token": SessionManager.instance.token,
            "v": "5.74"
        ]
        let url = baseUrl + "/photos.get"
        
        Alamofire.request(url, method: .get, parameters: params).responseData { repsons in
            guard let data = repsons.value else { return }
            let json = try! JSON(data: data)
//            print(json)
            let photos = json["response"]["items"].compactMap { Photo(json: $0.1) }
            self.savePhotosData(photos, userID: userID)
        }
    }
    
    func savePhotosData(_ photos: [Photo], userID: Int) {
        do {
            let realm = try Realm()
            guard let userIdAlbum = realm.object(ofType: FriendInfo.self, forPrimaryKey: userID) else { return }
            let oldPhotos = userIdAlbum.photos
            realm.beginWrite()
            realm.delete(oldPhotos)
            realm.add(photos, update: true)
            userIdAlbum.photos.append(objectsIn: photos)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func getGroups() {
        let params: Parameters = [
            "extended": 1,
            "access_token": SessionManager.instance.token,
            "v": vkApiVer
        ]
        let url = baseUrl + "/groups.get"
        
        Alamofire.request(url, method: .get, parameters: params).responseData { repsons in
            guard let data = repsons.value else { return }
            let json = try! JSON(data: data)
            let groups = json["response"]["items"].compactMap { Groups(json: $0.1) }
             self.saveGroupData(groups)
        }
    }
    
    func saveGroupData(_ groups: [Groups]) {
        do {
            let realm = try Realm()
            let oldGroups = realm.objects(Groups.self)
            realm.beginWrite()
            realm.delete(oldGroups)
            realm.add(groups, update: true)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func leaveGroups(groupID: Int, completion: @escaping ([GroupsLeave]) -> Void) {
        let params: Parameters = [
            "group_id": groupID,
            "access_token": SessionManager.instance.token,
            "v": vkApiVer
        ]
        let url = baseUrl + "/groups.leave"
        
        Alamofire.request(url, method: .get, parameters: params).responseData { repsons in
            guard let data = repsons.value else { return }
            let json = try! JSON(data: data)
            let groupLeave = json.compactMap { GroupsLeave(json: $0.1) }
            completion(groupLeave)
        }
    }
    
    func getSearchGroups(_ searchBar: UISearchBar, completion: @escaping ([NewGroupsSearch]) -> Void) {
        let params: Parameters = [
            "q": searchBar.text!,
            "access_token": SessionManager.instance.token,
            "v": vkApiVer
        ]
        let url = baseUrl + "/groups.search"
        
        Alamofire.request(url, method: .get, parameters: params).responseData { repsons in
            guard let data = repsons.value else { return }
            let json = try! JSON(data: data)
            let groupsSearch = json["response"]["items"].compactMap { NewGroupsSearch(json: $0.1) }
            completion(groupsSearch)
        }
    }
    
    func loadNewsPost(completion: @escaping ([News]) -> Void ) {
        let params: Parameters = [
            "v": vkApiVer
        ]
        let url = baseUrl + "/newsfeed.get"
        
        Alamofire.request(url, method: .get, parameters: params).responseData (queue: DispatchQueue.global()) { repsons in
            guard let data = repsons.value else { return }
            let json = try! JSON(data: data)
            //            print(json)
            let post = json["response"]["items"].compactMap { News(json: $0.1) }
            let profiles = json["response"]["profiles"].compactMap { NewsProfiles(json: $0.1) }
            let groups = json["response"]["groups"].compactMap { NewsGroups(json: $0.1) }
            for i in 0..<post.count {
                if post[i].sourceID > 0 {
                    print("Ошибка")
                } else {
                    let soursId = -1 * post[i].sourceID
                    for group in groups {
                        if group.groupID == soursId {
                            post[i].avatar = group.avatar
                            post[i].name = group.name
                        }
                    }
                    for profile in profiles {
                        if profile.userID == soursId {
                            post[i].avatar = profile.avatar
                            post[i].name = profile.firstName + " " + profile.lastName
                        }
                    }
                }
            }
            completion(post)
        }
    }
}
