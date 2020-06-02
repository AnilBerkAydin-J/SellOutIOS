//
//  CityProductModel.swift
//  SellOut
//
//  Created by Anil Berk Aydin on 4/28/20.
//  Copyright © 2020 Anil Berk Aydin. All rights reserved.
//

import Foundation
import UIKit

class CityProductModel{
    
    var userName: String
    var productName: String
    var price: Double
    var image: UIImage
    var lat: Double
    var long: Double
    var pKey: String
    var cat: String
    var toID: String
    
    
    init(name: String, pName: String, price: Double, image: UIImage, lat: Double, long: Double, pKey:String, cat: String, toID: String) {
        userName = name
        productName = pName
        self.price = price
        self.image = image
        self.lat = lat
        self.long = long
        self.pKey = pKey
        self.cat = cat
        self.toID = toID
    }
    
    
}
