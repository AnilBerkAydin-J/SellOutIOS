//
//  MyProductsVC.swift
//  SellOut
//
//  Created by Anil Berk Aydin on 4/15/20.
//  Copyright © 2020 Anil Berk Aydin. All rights reserved.
//

import UIKit
import Firebase


class MyProductsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   

    @IBOutlet weak var myTableView: UITableView!
    
    let db = Database.database().reference()
    var index = 0
    var products = [MyProductModel]()
    override func viewDidLoad() {
        super.viewDidLoad()

        
        createSpinnerView()
        myTableView.delegate = self
        myTableView.dataSource = self
        getData()
        myTableView.reloadData()
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
        
        let key = Auth.auth().currentUser?.uid
        self.products.removeAll(keepingCapacity: true)
        self.db.child("usersProducts").child(key!).observe(DataEventType.value) { (snapshot) in
    
            let array:NSArray = snapshot.children.allObjects as NSArray

            for obj in array {
                        print("OBJECTTTTTTT\(obj)")
                        let snapshot:DataSnapshot = obj as! DataSnapshot
                       print("SNAPSHOTTTTTT\(snapshot)")
                        
                        let pKey = (snapshot as AnyObject).key as String
                        if let value = snapshot.value as? [String : AnyObject]
                             {
                           var status = ""
                            let date = value["date"] as? String ?? ""
                            let productName = value["name"] as? String ?? ""
                            let price = value["price"] as? Double ?? 0.0
                            let statusCheck = value["status"] as? String ?? ""
                                let toID = value["id"] as? String ?? ""
                            let catName = value["category"] as? String ?? ""
                                if statusCheck == "0" {
                                    status = "Satışta"
                                }
                                else {
                                    status = "Satıldı"
                                }
                            
                            let imageUrl = value["image1"] as? String ?? "https://as1.ftcdn.net/jpg/02/71/86/48/500_F_271864847_qVuzNqkJcnIAjkL9n5OHTsNaPTLqZbpG.jpg"
                            let url = URL(string: imageUrl)
                            let data = try? Data(contentsOf: url!)
                            let image = UIImage(data: data!)
                                let product = MyProductModel(d: date, pName: productName, price: price, image:image!, status: status, pKey: pKey, catName: catName, toID: toID)
                            self.products.append(product)
                            
                            }
            }
            
           DispatchQueue.main.async {
               self.myTableView.reloadData()
            if self.products.count == 0 {
                self.makeAlert(titleInput: "Hata!", messageInput: "Henüz görüntülenecek ilanınız bulunmamaktadır.")
            }
           }
            
        }
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
        
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "ilanTableCell", for: indexPath) as! ilanTableCell
        cell.dateLabel.text = products[indexPath.row].date
        cell.priceLabel.text = String(products[indexPath.row].price)+" TL"
        cell.productNameLabel.text = products[indexPath.row].productName
        cell.productView.image = products[indexPath.row].image
        cell.statusLabel.text = products[indexPath.row].status
        return cell
       }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "toDetailVC", sender: nil)
    }
       
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            if let DetailVC = segue.destination as? DetailsVC {
                DetailVC.pKey = products[index].pKey
                DetailVC.catName = products[index].catName
                DetailVC.toUserID = products[index].toID
            }
        }
    }
    
    func makeAlert(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okBt = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okBt)
        self.present(alert, animated: true, completion: nil)
        
    }

}
