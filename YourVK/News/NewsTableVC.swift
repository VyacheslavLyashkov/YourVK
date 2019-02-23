//
//  NewsTableVC.swift
//  YourVK
//
//  Created by Vyacheslav Lyashkov on 16/02/2019.
//  Copyright © 2019 Vyacheslav Lyashkov. All rights reserved.
//

import UIKit

class NewsTableVC: UITableViewController {
    
    var newsPost = [News]()
    var newsProfiles = [FriendInfo]()
    var newsGroups = [Groups]()
    var vkService = VKService()
    var photoService: PhotoServiceWithoutDiskCache?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vkService.loadNewsPost() {[weak self] post in
            self?.newsPost = post
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        photoService = PhotoServiceWithoutDiskCache(container: tableView)
        tableView.register(GenericNewsTableViewCell.self, forCellReuseIdentifier: GenericNewsTableViewCell.reuseIdentifier())
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsPost.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GenericNewsTableViewCell.reuseIdentifier(), for: indexPath) as! GenericNewsTableViewCell
        
        let post = newsPost[indexPath.row]
        cell.configure(post: post,
                       photo: photoService?.photo(atIndexpath: indexPath, byUrl: post.photo), avatar: photoService?.photo(atIndexpath: indexPath, byUrl: post.avatar))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let post = newsPost[indexPath.row]
        let hasPhoto = photoService?.photo(atIndexpath: indexPath, byUrl: post.photo) != nil
        return GenericNewsTableViewCell.cellHeigth(newsText: post.text, hasPhoto: hasPhoto, cellWidth: tableView.bounds.width)
    }
}
