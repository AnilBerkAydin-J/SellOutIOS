//
//  CategoryVC.swift
//  SellOut
//
//  Created by Anil Berk Aydin on 4/15/20.
//  Copyright © 2020 Anil Berk Aydin. All rights reserved.
//

import UIKit
import Firebase
import iOSDropDown

class CategoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    var key = ""
    let db = Database.database().reference()
    var products = [CategoryDetailModel]()
    var index = 0
    
    @IBOutlet weak var priceFilt: UIBarButtonItem!
    
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
       
        createSpinnerView()
        getData()
        categoryTableView.reloadData()
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
          
        self.db.child("categories").child(key).queryOrdered(byChild: "price").observeSingleEvent(of: .value) { (snapshot) in
                 
                
           let array:NSArray = snapshot.children.allObjects as NSArray

           for obj in array {
               let snapshot:DataSnapshot = obj as! DataSnapshot
               let pKey = (snapshot as AnyObject).key as String
               
               if let value = snapshot.value as? [String : AnyObject]
                    {
                   
                   let name = value["username"] as? String ?? ""
                   let adress = value["adress"] as? String ?? ""
                   let price = value["price"] as? Double ?? 0
                   let date = value["date"] as? String ?? ""
                   let toID = value["toID"] as? String ?? ""
                   let imageUrl = value["image1"] as? String ?? "https://as1.ftcdn.net/jpg/02/71/86/48/500_F_271864847_qVuzNqkJcnIAjkL9n5OHTsNaPTLqZbpG.jpg"
                   let url = URL(string: imageUrl)
                   let data = try? Data(contentsOf: url!)
                   let image = UIImage(data: data!)
                        let product = CategoryDetailModel(d: date, price: price, image: image!, adress:adress, name: name, pKey: pKey, catName: self.key, toID: toID)
                   self.products.append(product)
                        
                        self.categoryTableView.reloadData()
                   }
               
           }
               
                 
        }
              
         
              OperationQueue.main.addOperation({
                  self.categoryTableView.reloadData()
              })
          
          
      }

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return products.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = categoryTableView.dequeueReusableCell(withIdentifier: "CategoryVCCell", for: indexPath) as! CategoryVCCell
    cell.adressLabel.text = products[indexPath.row].adress
    cell.priceLabel.text = "\(String(products[indexPath.row].price)) TL"
    cell.dateLabel.text = products[indexPath.row].date
    cell.userNameLabel.text = products[indexPath.row].name
    cell.categoryImageView.image = products[indexPath.row].image
        
         return cell
   }
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    @IBAction func reverseClicked(_ sender: Any) {
        self.products.reverse()
        self.categoryTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "catToDetailVC", sender: nil)
    }
       
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "catToDetailVC" {
            if let DetailVC = segue.destination as? DetailsVC {
                DetailVC.pKey = products[index].pKey
                DetailVC.catName = products[index].catName
                DetailVC.toUserID = products[index].toID
            }
        }
    }
    
}
