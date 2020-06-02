//
//  SplashViewController.swift
//  SellOut
//
//  Created by Anil Berk Aydin on 26.05.2020.
//  Copyright © 2020 Anil Berk Aydin. All rights reserved.
//

import UIKit
import Firebase

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        assignBackground()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.checkUserNil()
        }
        
        
    }
    
    func assignBackground(){
        let background = UIImage(named: "back_login.png")!
        
        var imageView: UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    func checkUserNil() {
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "userNotNil", sender: nil)
        }else {
            performSegue(withIdentifier: "userNil", sender: nil)
        }
    }
    


}
