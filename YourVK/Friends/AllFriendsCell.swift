//
//  AllFriendsCell.swift
//  YourVK
//
//  Created by Vyacheslav Lyashkov on 31.08.2018.
//  Copyright © 2018 Vyacheslav Lyashkov. All rights reserved.
//

import RealmSwift
import UIKit

class AllFriendsCell: UITableViewCell {
    
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendAvatarView: UIView!
    var otherSubContent = UIImageView()
    let borderView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Здесь выполняется так конфигурация, которую достаточно сделать один раз
        borderView.frame = self.friendAvatarView.bounds
        borderView.layer.cornerRadius = self.friendAvatarView.frame.size.width / 2
        borderView.layer.borderColor = UIColor.black.cgColor
        borderView.layer.borderWidth = 0.1
        borderView.layer.masksToBounds = true
        self.friendAvatarView.addSubview(borderView)
        
        
        borderView.addSubview(otherSubContent)
        
        self.friendAvatarView.layer.shadowColor = UIColor.black.cgColor
        self.friendAvatarView.layer.shadowOffset = CGSize.zero
        self.friendAvatarView.layer.shadowOpacity = 0.5
        self.friendAvatarView.layer.shadowRadius = 4
    }
    
    public func configure(firstName: String, lastName: String, indexPath: IndexPath) {
        // А это специальный метод, который будет менять то, что должно меняться
        self.friendName.text = firstName + " " + lastName
    }
    
    override func layoutSubviews() {
        // Здесь конфигурация, которая зависит от размера ячейкм
        self.friendAvatarView.layer.cornerRadius = self.friendAvatarView.frame.size.width / 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
