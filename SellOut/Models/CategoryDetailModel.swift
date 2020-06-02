//
//  CategoryDetailModel.swift
//  SellOut
//
//  Created by Anil Berk Aydin on 4/15/20.
//  Copyright © 2020 Anil Berk Aydin. All rights reserved.
//

import Foundation
import UIKit

class CategoryDetailModel{
    
    var date: String
    var adress: String
    var price: Double
    var image: UIImage
    var name: String
    var pKey: String
    var catName: String
    var toID: String
   
    
    init(d: String,  price: Double, image: UIImage, adress: String, name: String, pKey: String, catName: String, toID: String) {
        date = d
        self.price = price
        self.image = image
        self.adress = adress
        self.name = name
        self.pKey = pKey
        self.catName = catName
        self.toID = toID
    }
    
    
}
