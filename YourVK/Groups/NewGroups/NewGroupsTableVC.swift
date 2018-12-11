//
//  NewGroupsTableVC.swift
//  YourVK
//
//  Created by Vyacheslav Lyashkov on 31.08.2018.
//  Copyright © 2018 Vyacheslav Lyashkov. All rights reserved.
//

import UIKit

class NewGroupsTableVC: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var selectedRow = 0
    var groups = [NewGroupsSearch]()
    let vkService = VKService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.placeholder = "Ведите запрос..."
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "newGroupCell", for: indexPath) as! NewGroupsCell
        let group = groups[indexPath.row]
        let groupAvatar = groups[indexPath.row].groupAvatar
        
        cell.newGroupName.text = group.groupName
        
        cell.groupAvatar.layer.cornerRadius = cell.groupAvatar.frame.size.width / 2
        cell.groupAvatar.layer.shadowColor = UIColor.black.cgColor
        cell.groupAvatar.layer.shadowOffset = CGSize.zero
        cell.groupAvatar.layer.shadowOpacity = 0.5
        cell.groupAvatar.layer.shadowRadius = 4
        
        let borderView = UIView()
        borderView.frame = cell.groupAvatar.bounds
        borderView.layer.cornerRadius = cell.groupAvatar.frame.size.width / 2
        borderView.layer.borderColor = UIColor.black.cgColor
        borderView.layer.borderWidth = 0.1
        borderView.layer.masksToBounds = true
        cell.groupAvatar.addSubview(borderView)
        
        let otherSubContent = UIImageView()
        do {
            try cell.groupAvatar.image = UIImage(data: Data(contentsOf: URL(string:groupAvatar)!))!
        } catch {
            print(error)
        }
        otherSubContent.frame = borderView.bounds
        otherSubContent.contentMode = UIView.ContentMode.scaleAspectFill
        borderView.addSubview(otherSubContent)
        
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        vkService.getSearchGroups(searchBar) { [weak self] groups in
            self?.groups = groups
        }
        if searchText == "" {
            groups = []
        }
        self.tableView.reloadData()
    }
}
