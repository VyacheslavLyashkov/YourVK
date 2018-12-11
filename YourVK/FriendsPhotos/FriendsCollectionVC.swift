//
//  FriendsCollectionVC.swift
//  YourVK
//
//  Created by Vyacheslav Lyashkov on 31.08.2018.
//  Copyright © 2018 Vyacheslav Lyashkov. All rights reserved.
//

import RealmSwift
import UIKit

class FriendsCollectionVC: UICollectionViewController {
    
    var selectedRow = 0
    var selectedUserID = 0
    var photos: List<Photo>?
    var vkService = VKService()
    var tokenNotifi: NotificationToken?
    var photoService: PhotoService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vkService.getPhotos(userID: selectedUserID)
        pairTableAndRealm()
        photoService = PhotoService(container: collectionView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendCollectionCell", for: indexPath) as! FriendsCollectionCell
        let friendPhotos = photos?[indexPath.row].photo ?? ""
        
        cell.friendPhotos.image = photoService?.photo(atIndexpath: indexPath, byUrl: friendPhotos)

        return cell
    }
    
    func pairTableAndRealm() {
        guard let realm = try? Realm(), let photo = realm.object(ofType: FriendInfo.self, forPrimaryKey: selectedUserID)
            else { return }
        photos = photo.photos
        tokenNotifi = photos?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let collectionView = self?.collectionView else { return }
            switch changes {
            case .initial:
                collectionView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                collectionView.performBatchUpdates({
                    collectionView.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0) }))
                    collectionView.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0)}))
                    collectionView.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0) }))
                }, completion: nil)
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
}
