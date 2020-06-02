//
//  CategoryCell.swift
//  SellOut
//
//  Created by Anil Berk Aydin on 4/7/20.
//  Copyright © 2020 Anil Berk Aydin. All rights reserved.
//

import UIKit


class CategoryCell: UITableViewCell {
    

   
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categoryLabel: UILabel!
    var name = ""
    var pName = ""
    var price = ""
    var image2 = UIImage()
    var products = [productModel]()
    override func awakeFromNib() {
        super.awakeFromNib()
        
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    func setCollectionViewDataSourceDelegate <D: UICollectionViewDataSource & UICollectionViewDelegate>
       (dataSourceDelegate: D, forRow row: Int) {

           collectionView.delegate = dataSourceDelegate
           collectionView.dataSource = dataSourceDelegate
           collectionView.tag = row
           collectionView.reloadData()
       }
    
    

}

