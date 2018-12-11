//
//  AllFriendsTableVC.swift
//  YourVK
//
//  Created by Vyacheslav Lyashkov on 31.08.2018.
//  Copyright © 2018 Vyacheslav Lyashkov. All rights reserved.
//

import RealmSwift
import UIKit

class AllFriendsTableVC: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var segueID = "friendsCollectionSegue"
    private var selectedRow = 0
    let vkService = VKService()
    var friends: Results<FriendInfo>?
    var tokenNotifi: NotificationToken?
    var photoService: PhotoService?
    
//    let items = try! Realm().objects(FriendInfo.self).sorted(by: ["firstName", "lastName", "avatar"])
//    var sectionNames: [String] {
//        return Set(items.value(forKeyPath: "lastName") as! [String]).sorted()
//    }
    
//    struct friendsObjects {
//        var sectionName : String!
//        var sectionObjects : [String]!
//    }
//
//    var friendsObjectArray = [friendsObjects]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pairTableAndRealm()
        vkService.getFriends()
        photoService = PhotoService(container: tableView)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! AllFriendsCell
        let friendFirstName = friends?[indexPath.row].firstName ?? ""
        let friendLastName = friends?[indexPath.row].lastName ?? ""
        let friendAvatar = friends?[indexPath.row].avatar ?? ""
        
        cell.otherSubContent.frame = cell.borderView.bounds
        cell.otherSubContent.contentMode = UIView.ContentMode.scaleAspectFill
        cell.otherSubContent.image = photoService?.photo(atIndexpath: indexPath, byUrl: friendAvatar)
        cell.configure(firstName: friendFirstName, lastName: friendLastName, indexPath: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        performSegue(withIdentifier: segueID, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueID {
            if let destination = segue.destination as? FriendsCollectionVC {
                destination.selectedRow = selectedRow
                destination.selectedUserID = friends?[selectedRow].userID ?? 0
            }
        }
    }
    
    func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        friends = realm.objects(FriendInfo.self)
        tokenNotifi = friends?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
                break
            case .error(let error):
                fatalError("\(error)")
                break
            }
        }
    }
}
