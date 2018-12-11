//
//  GroupsTableVC.swift
//  YourVK
//
//  Created by Vyacheslav Lyashkov on 31.08.2018.
//  Copyright © 2018 Vyacheslav Lyashkov. All rights reserved.
//

import RealmSwift
import UIKit

class GroupsTableVC: UITableViewController {
    
    var vkService = VKService()
    var groups: Results<Groups>?
    var groupsLeave = [GroupsLeave]()
    var selectedGroupID = 0
    var tokenNotifi: NotificationToken?
    var photoService: PhotoService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pairTableAndRealm()
        vkService.getGroups()
        photoService = PhotoService(container: tableView)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! GroupsCell
        let group = groups?[indexPath.row]
        let groupAvatar = groups?[indexPath.row].groupAvatar ?? ""
        
        cell.groupName.text = group?.groupName ?? ""
        cell.groupAvatar.layer.cornerRadius = cell.groupAvatar.frame.size.height / 2
        cell.groupAvatar.layer.masksToBounds = true
        
        cell.groupAvatar.image = photoService?.photo(atIndexpath: indexPath, byUrl: groupAvatar)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Покинуть сообщество") { _, indexPath in
            let groupId = self.groups?[indexPath.row].groupId ?? 0
            let groupName = self.groups?[indexPath.row].groupName ?? ""
            let alert = UIAlertController(title: "", message: "Вы уверены что хотите покинуть сообщество " + groupName + "?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Да", style: .default) { (sender: UIAlertAction) -> Void in
                self.vkService.leaveGroups(groupID: groupId) {[weak self] groupsLeave in
                    guard let realm = try? Realm(),
                        let group = self?.groups?[indexPath.row] else { return }
                    try! realm.write {
                        realm.delete(group)
                    }
                }
            })
            alert.addAction(UIAlertAction(title: "Нет", style: .cancel) { (sender: UIAlertAction) -> Void in })
            self.present(alert, animated: true, completion: nil)
        }
        return [deleteAction]
    }
    
    func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        groups = realm.objects(Groups.self)
        tokenNotifi = groups?.observe { [weak self] (changes: RealmCollectionChange) in
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
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            groups.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
//
//    @IBAction func addGroup(segue: UIStoryboardSegue) {
//
//        if segue.identifier == "addGroup" {
//
//            let allGropusController = segue.source as! NewGroupsTableVC
//
//            if let indexPath = allGropusController.tableView.indexPathForSelectedRow {
//                    let group = allGropusController.groups[indexPath.row]
//                if !groups.contains(group) {
//                    groups.append(group)
//                    tableView.reloadData()
//                }
//                    let groupAvatar = allGropusController.groupAvatar[indexPath.row]
//                if !groupsAvatar.contains(groupAvatar) {
//                    groupsAvatar.append(groupAvatar)
//                    tableView.reloadData()
//                }
//            }
//        }
//    }
}
