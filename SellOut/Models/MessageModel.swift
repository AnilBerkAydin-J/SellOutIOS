//
//  MessageModel.swift
//  SellOut
//
//  Created by Anil Berk Aydin on 5/6/20.
//  Copyright © 2020 Anil Berk Aydin. All rights reserved.
//

import Foundation

struct  MessageModel {
    let text: String
    let toID : String
    let fromID: String
    
    init(text:String, toID:String, fromID: String) {
        self.text = text
        self.toID = toID
        self.fromID = fromID
    }
    
}
