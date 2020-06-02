//
//  MessageListModel.swift
//  SellOut
//
//  Created by Anil Berk Aydin on 5/7/20.
//  Copyright © 2020 Anil Berk Aydin. All rights reserved.
//

import Foundation

struct  MessageListModel {
    let text: String
    let name : String
    let imageUrl: String
    
    init(text: String, name: String, imageUrl: String) {
        self.text = text
        self.name = name
        self.imageUrl = imageUrl
    }
    
}
