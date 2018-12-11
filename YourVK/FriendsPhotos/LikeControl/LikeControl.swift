//
//  LikeControl.swift
//  YourVK
//
//  Created by Vyacheslav Lyashkov on 04.09.2018.
//  Copyright © 2018 Vyacheslav Lyashkov. All rights reserved.
//

import UIKit

class LikeControl: UIControl {
    
    @IBOutlet weak var likeButton: UIButton! {
        didSet {
            self.likeButton.setImage(#imageLiteral(resourceName: "unliked"), for: .normal)
            self.likeButton.setImage(#imageLiteral(resourceName: "liked"), for: .selected)
        }
    }
    @IBOutlet weak var likesLabel: UILabel!
    
    private var likeCounter = 0 {
        didSet {
            self.likesLabel?.text = String(likeCounter) + " likes"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    private func commonInit() {
        //style and configuration
    }
    
    override func layoutSubviews() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(LikeControl.handleTap(_:)))
        
        self.likeButton.addGestureRecognizer(tapGR)
    }
    
    @objc func handleTap(_: UITapGestureRecognizer) {
        
        self.likeButton.isSelected = !self.likeButton.isSelected
        if likeCounter == 0{
            likeCounter += 1
        }else{
            likeCounter -= 1
        }
        
        sendActions(for: .valueChanged)
    }
}
