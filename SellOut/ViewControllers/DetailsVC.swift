//
//  DetailsVC.swift
//  SellOut
//
//  Created by Anil Berk Aydin on 4/15/20.
//  Copyright © 2020 Anil Berk Aydin. All rights reserved.
//

import UIKit
import Firebase

class DetailsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var soldButton: UIButton!
    @IBOutlet weak var sentButton: UIButton!
    @IBOutlet weak var detailCommentLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var detailDateLabel: UILabel!
    @IBOutlet weak var detailUserNameLabel: UILabel!
    @IBOutlet weak var detailProductNameLable: UILabel!
    @IBOutlet weak var detailCV: UICollectionView!
    @IBOutlet weak var detailPriceLabel: UILabel!
    
    let db = Database.database().reference()
    var pKey = ""
    var catName = ""
    var flag = false
    var images = [Data]()
    var toUserID = ""
    let key = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImage?.layer.cornerRadius = (userImage?.frame.size.width ?? 0.0) / 2
        userImage?.clipsToBounds = true
        userImage?.layer.borderWidth = 5.0
        userImage?.layer.borderColor = UIColor.white.cgColor

        
        detailCV.delegate = self
        detailCV.dataSource = self
        
        createSpinnerView()
        getData()
        detailCV.reloadData()
        // Do any additional setup after loading the view.
    }
    
    
    func createSpinnerView() {
        let child = SpinnerViewController()

        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)

        // wait two seconds to simulate some work happening
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // then remove the spinner view controller
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
    func getData(){
 
            self.db.child("categories").child(self.catName).child(self.pKey).observeSingleEvent(of: .value) { (snapshot) in
               
                let value = snapshot.value as? NSDictionary
                                
                self.detailProductNameLable.text = value?["name"] as! String
                self.detailCommentLabel.text = value?["comment"] as! String
                self.detailDateLabel.text = "Ürünün yayınlanma tarihi: "+(value?["date"] as! String)
                self.detailUserNameLabel.text = value?["username"] as? String ?? ""
                self.detailPriceLabel.text = String(value?["price"] as? Double ?? 0.0)+" TL"
                self.toUserID = value?["toID"] as! String
                self.getImage(toId: self.toUserID)
                let imageUrl1 = value?["image1"] as! String ?? "https://as1.ftcdn.net/jpg/02/71/86/48/500_F_271864847_qVuzNqkJcnIAjkL9n5OHTsNaPTLqZbpG.jpg"
                let url1 = URL(string: imageUrl1)
                let data1 = try? Data(contentsOf: url1!)
                let image1 = UIImage(data: data1!)
                
                let imageUrl2 = value?["image2"] as! String ?? "https://as1.ftcdn.net/jpg/02/71/86/48/500_F_271864847_qVuzNqkJcnIAjkL9n5OHTsNaPTLqZbpG.jpg"
                let url2 = URL(string: imageUrl2)
                let data2 = try? Data(contentsOf: url2!)
                                    let image2 = UIImage(data: data2!)
                let imageUrl3 = value?["image3"] as! String ?? "https://as1.ftcdn.net/jpg/02/71/86/48/500_F_271864847_qVuzNqkJcnIAjkL9n5OHTsNaPTLqZbpG.jpg"
                let url3 = URL(string: imageUrl3)
                let data3 = try? Data(contentsOf: url3!)
                let image3 = UIImage(data: data3!)
                let imageUrl4 = value?["image4"] as! String ?? "https://as1.ftcdn.net/jpg/02/71/86/48/500_F_271864847_qVuzNqkJcnIAjkL9n5OHTsNaPTLqZbpG.jpg"
                let url4 = URL(string: imageUrl4)
                let data4 = try? Data(contentsOf: url4!)
                let image4 = UIImage(data: data4!)
                self.images.append(data1!)
                self.images.append(data2!)
                self.images.append(data3!)
                self.images.append(data4!)
                
                self.detailCV.reloadData()
               }
            
           
            if  self.key != self.toUserID {
                self.soldButton.isHidden = true
                self.cancelButton.isHidden = true
                self.sentButton.isHidden = false
            }else {
                self.soldButton.isHidden = false
                self.cancelButton.isHidden = false
                self.sentButton.isHidden = true
            }
            OperationQueue.main.addOperation({
                self.detailCV.reloadData()
            })
        
    }
    
    func getImage(toId: String){
        self.db.child("users").child(toId).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            //let username = value?["username"] as! String
            print(value)
            let url = URL(string: value?["photoUrl"] as! String)
            let data = try? Data(contentsOf: url!)
            let image = UIImage(data: data!)
            self.userImage.image = image
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("GİRDİMİ")
        print(images.count)
        return images.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          print("GİRDİMİ2")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCVCell", for: indexPath) as! DetailCVCell
        cell.imagesView.image = UIImage(data: images[indexPath.row])
       
          
           
    
           return cell
       }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 190, height: 171)
    }
        

    @IBAction func sentClicked(_ sender: Any) {
        performSegue(withIdentifier: "toMessageVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMessageVC" {
            if let MessageVC = segue.destination as? MessageVC {
                MessageVC.toUserID = self.toUserID
                
            }
        }
    }
    
    @IBAction func soldClicked(_ sender: Any) {
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
    }
}
