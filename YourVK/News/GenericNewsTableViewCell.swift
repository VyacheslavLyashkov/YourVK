//
//  GenericNewsTableViewCell.swift
//  YourVK
//
//  Created by Vyacheslav Lyashkov on 16/02/2019.
//  Copyright © 2019 Vyacheslav Lyashkov. All rights reserved.
//

import UIKit

class GenericNewsTableViewCell: UITableViewCell {
    
    let instets: CGFloat = 10.0
    
    let authorAvatar = UIImageView()
    let authorName = UILabel()
    let newsText = UILabel()
    let newsLikes = UILabel()
    let newsComments = UILabel()
    let newsReposts = UILabel()
    let newsViews = UILabel()
    let newsPhoto = UIImageView()
    
    var hasText = false
    var hasPhoto = false
    var hasAvatar = false
    
    var photoService: PhotoService?
    
    static func reuseIdentifier() -> String {
        return "GenericNewsTableViewCell"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.clipsToBounds = true
        
        authorAvatar.layer.cornerRadius = 25
        authorAvatar.layer.masksToBounds = true
        
        newsText.font = UIFont.systemFont(ofSize: 17.0)
        newsText.numberOfLines = 0
        
        newsPhoto.clipsToBounds = true
        newsPhoto.contentMode = UIView.ContentMode.scaleAspectFill
        
        contentView.addSubview(authorAvatar)
        contentView.addSubview(authorName)
        contentView.addSubview(newsText)
        contentView.addSubview(newsPhoto)
        contentView.addSubview(newsLikes)
        contentView.addSubview(newsComments)
        contentView.addSubview(newsReposts)
        contentView.addSubview(newsViews)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(post: News, photo: UIImage?, avatar: UIImage?) {
        authorName.text = post.name
        newsLikes.text = String(post.likes)
        newsComments.text = String(post.comments)
        newsReposts.text = String(post.reposts)
        newsViews.text = String(post.views)
        
        hasText = post.text.count != 0
        if (hasText) {
            newsText.text = post.text
        }
        
        hasPhoto = (photo != nil)
        if (hasPhoto) {
            newsPhoto.image = photo
        }
        
        hasAvatar = (avatar != nil)
        if (hasAvatar) {
            authorAvatar.image = avatar
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        authorAvatar.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
        
        let authorNameRect = authorName.sizeThatFits(CGSize(
            width: contentView.bounds.width - authorAvatar.frame.maxX + 20,
            height: CGFloat.greatestFiniteMagnitude))
        
        authorName.frame = CGRect(
            x: authorAvatar.frame.maxX + 10,
            y: authorAvatar.frame.midY - authorName.frame.size.height / 2,
            width: authorNameRect.width,
            height: authorNameRect.height)
        
        if (hasText) {
            let newsTextRect = newsText.sizeThatFits(CGSize(
                width: contentView.bounds.width - 20,
                height: CGFloat.greatestFiniteMagnitude))
            
            newsText.frame = CGRect(x: 10, y: authorAvatar.frame.maxY + 10, width: newsTextRect.width, height: newsTextRect.height)
        } else {
            newsText.frame = CGRect(x: 10, y: authorAvatar.frame.maxY + 10, width: 0, height: 0)
        }
        
        if (hasPhoto) {
            newsPhoto.frame = CGRect(
                x: 10,
                y: (hasText ? newsText.frame.maxY : authorAvatar.frame.maxY) + 10,
                width: contentView.frame.size.width - 20,
                height: contentView.frame.size.width - 20)
        } else {
            newsPhoto.frame = CGRect(
                x: 10,
                y: (hasText ? newsText.frame.maxY : authorAvatar.frame.maxY),
                width: 0,
                height: 0)
        }
        
        let counters: [UILabel] = [newsLikes, newsComments, newsReposts, newsViews]
        for i in 0..<counters.count {
            let width = (contentView.bounds.width - 20) / CGFloat(counters.count)
            let view = counters[i]
            view.frame = CGRect(x: 10 + width * CGFloat(i),
                                y: newsPhoto.frame.maxY + 10,
                                width: width,
                                height: 20)
        }
    }
    
    static func cellHeigth(newsText: String?, hasPhoto: Bool, cellWidth: CGFloat) -> CGFloat {
        var height: CGFloat = 60
        
        if let t = newsText {
            let text = NSAttributedString(string: t, attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17.0)
                ])
            let textFrame = text.boundingRect(with: CGSize(
                width: cellWidth - 20,
                height: CGFloat.greatestFiniteMagnitude),
                                              options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                              context: nil)
            height += textFrame.size.height + 10
        }
        
        if hasPhoto {
            height += cellWidth - 20 + 10
        }
        
        return height + 10 + 30
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
