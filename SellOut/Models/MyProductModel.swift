//
//  MyProductModel.swift
//  SellOut
//
//  Created by Anil Berk Aydin on 4/15/20.
//  Copyright © 2020 Anil Berk Aydin. All rights reserved.
//

import Foundation
import UIKit

class MyProductModel{
    
    var date: String
    var productName: String
    var price: Double
    var image: UIImage
    var status: String
    var pKey: String
    var catName: String
    var toID: String
    
    init(d: String, pName: String, price: Double, image: UIImage, status: String, pKey: String, catName: String, toID: String) {
        date = d
        productName = pName
        self.price = price
        self.image = image
        self.status = status
        self.pKey = pKey
        self.catName = catName
        self.toID = toID
    }
    
    
}

