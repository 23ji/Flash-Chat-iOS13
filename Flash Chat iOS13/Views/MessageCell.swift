//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by 이상지 on 5/4/25.
//  Copyright © 2025 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
  
  @IBOutlet weak var messageBubble: UIView!
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var rightImageView: UIImageView!
  @IBOutlet weak var leftImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.messageBubble.layer.cornerRadius = self.messageBubble.frame.height / 5
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    //초기화
    self.rightImageView.isHidden = false
    self.leftImageView.isHidden = false
  }
}
