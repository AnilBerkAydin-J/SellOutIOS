//
//  productModel.swift
//  SellOut
//
//  Created by Anil Berk Aydin on 4/13/20.
//  Copyright © 2020 Anil Berk Aydin. All rights reserved.
//

import Foundation
import UIKit

class productModel{
    
    var userName: String
    var productName: String
    var price: Double
    var image: UIImage
    
    
    init(name: String, pName: String, price: Double, image: UIImage) {
        userName = name
        productName = pName
        self.price = price
        self.image = image
    }
    
    
}
