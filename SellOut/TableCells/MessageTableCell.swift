//
//  MessageTableCell.swift
//  SellOut
//
//  Created by Anil Berk Aydin on 5/7/20.
//  Copyright © 2020 Anil Berk Aydin. All rights reserved.
//

import UIKit

class MessageTableCell: UITableViewCell {

    @IBOutlet weak var messageTableTextLabel: UILabel!
    @IBOutlet weak var messageTableNameLabel: UILabel!
    @IBOutlet weak var messageTableImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        messageTableImageView?.layer.cornerRadius = (messageTableImageView?.frame.size.width ?? 0.0) / 2
        messageTableImageView?.clipsToBounds = true
        messageTableImageView?.layer.borderWidth = 3.0
        messageTableImageView?.layer.borderColor = UIColor.white.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
