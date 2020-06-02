//
//  MessageCollectionViewCell.swift
//  SellOut
//
//  Created by Anil Berk Aydin on 5/8/20.
//  Copyright © 2020 Anil Berk Aydin. All rights reserved.
//

import UIKit

class MessageCollectionViewCell: UICollectionViewCell {
    
    let bubbleContainer: UIView = {
       let view = UIView()
        view.backgroundColor = .systemPurple
        return view
    }()
    
   let textView: UITextView = {
       let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = .systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.text = ""
        return tv
    }()
   
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bubbleContainer.layer.cornerRadius = 12
        bubbleContainer.frame = CGRect(x: 12, y: 4, width: 250, height: 40)
        //bubbleContainer.bounds = bubbleContainer.frame.insetBy(dx: 12, dy: 0)
        addSubview(bubbleContainer)
    
        textView.frame = CGRect(x: 12, y: 4, width: 230, height: 30)
        bubbleContainer.addSubview(textView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
