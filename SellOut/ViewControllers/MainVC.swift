//
//  MainVC.swift
//  SellOut
//
//  Created by Anil Berk Aydin on 4/3/20.
//  Copyright © 2020 Anil Berk Aydin. All rights reserved.
//

import UIKit
import Firebase

class MainVC: CustomViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    var index = 0
    @IBOutlet weak var tableView: UITableView!
    var dataArray: [String: Any] = [:]
    let db = Database.database().reference()
    var nameArr: [String] = []
    var products = [productModel]()
    let catCell = CategoryCell()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        tabBarController?.tabBar.isTranslucent = false
        navigationController?.view.tintColor = UIColor.yellow
        tabBarController?.view.tintColor = UIColor.yellow
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 14.0/255.0, green: 47.0/255.0, blue: 86.0/255.0, alpha: 1.0)
        tabBarController?.tabBar.barTintColor = UIColor.init(red: 14.0/255.0, green: 47.0/255.0, blue: 86.0/255.0, alpha: 1.0)
      
        tableView.delegate = self
        tableView.dataSource = self
    
        createSpinnerView()
        addSlideMenuButton()
        getData()
        tableView.reloadData()
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
        
        self.nameArr.removeAll(keepingCapacity: true)
        self.products.removeAll(keepingCapacity: true)
        self.db.child("categories").observe(DataEventType.value) { (snapshot) in
            
            for res in snapshot.children {
                
                self.nameArr.append((res as AnyObject).key as String)
                self.tableView.reloadData()
                
                self.db.child("categories").child((res as AnyObject).key as String).observe(DataEventType.value) {(snapshot) in
                    let array:NSArray = snapshot.children.allObjects as NSArray

                    for obj in array {
                        let snapshot:DataSnapshot = obj as! DataSnapshot
                        if let value = snapshot.value as? [String : AnyObject]
                             {
                            
                            let name = value["username"] as? String ?? ""
                            let productName = value["name"] as? String ?? ""
                                let price = value["price"] as? Double ?? 0.0
                            let imageUrl = value["image1"] as? String ?? "https://as1.ftcdn.net/jpg/02/71/86/48/500_F_271864847_qVuzNqkJcnIAjkL9n5OHTsNaPTLqZbpG.jpg"
                            let url = URL(string: imageUrl)
                            let data = try? Data(contentsOf: url!)
                            let image = UIImage(data: data!)
                            let product = productModel(name: name, pName: productName, price: price, image:image!)
                            self.products.append(product)
                           
                            }
                    }
                }
            }
            
           DispatchQueue.main.async {
               self.tableView.reloadData()
           }
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return nameArr.count
        return nameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        //cell.categoryLabel.text = nameArr[indexPath.row]
        cell.categoryLabel.text = nameArr[indexPath.row]
        cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        cell.collectionView.reloadData()
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! productCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! productCell
        cell.nameLabel.text = products[indexPath.row].userName
      
        cell.priceLabel.text = String(products[indexPath.row].price)+" TL"
        
        cell.productNameLabel.text = products[indexPath.row].productName
        cell.productView.image = products[indexPath.row].image
       
        
        return cell
    }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: 206, height: 250)
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "toCategoryVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "toCategoryVC" {
               if let CategoryVC = segue.destination as? CategoryVC {
                CategoryVC.key = nameArr[index]
                   
               }
           }
       }
     
   
  
    
}
