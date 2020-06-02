//
//  CategoryVCCell.swift
//  SellOut
//
//  Created by Anil Berk Aydin on 4/15/20.
//  Copyright © 2020 Anil Berk Aydin. All rights reserved.
//

import UIKit

class CategoryVCCell: UITableViewCell {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
