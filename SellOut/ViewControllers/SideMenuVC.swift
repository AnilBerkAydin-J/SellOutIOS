//
//  SideMenuVC.swift
//  SellOut
//
//  Created by Anil Berk Aydin on 4/7/20.
//  Copyright © 2020 Anil Berk Aydin. All rights reserved.
//

import UIKit
import Firebase

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(index: Int32)
}

class SideMenuVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var sideTableView: UITableView!
    @IBOutlet weak var transButton: UIButton!
    var btnMenu: UIButton!
    var delegate: SlideMenuDelegate?
    var nameArr: [String] = []
    let db = Database.database().reference()
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        transButton.backgroundColor = UIColor.gray
        transButton.alpha = 0.4
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        sideTableView.delegate = self
        sideTableView.dataSource = self
        sideTableView.backgroundColor = UIColor.init(red: 14.0/255.0, green: 47.0/255.0, blue: 86.0/255.0, alpha: 1.0)
        getData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        transButton.backgroundColor = UIColor.gray
        transButton.alpha = 0.4
        sideTableView.delegate = self
        sideTableView.dataSource = self
        sideTableView.backgroundColor = UIColor.init(red: 14.0/255.0, green: 47.0/255.0, blue: 86.0/255.0, alpha: 1.0)
    }
    
    func getData(){
    
    self.nameArr.removeAll(keepingCapacity: true)
    
    self.db.child("categories").observe(DataEventType.value) { (snapshot) in
        
            for res in snapshot.children {
                self.nameArr.append((res as AnyObject).key as String)
                self.sideTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return nameArr.count
        return nameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        //cell.categoryLabel.text = nameArr[indexPath.row]
        cell.textLabel?.text = nameArr[indexPath.row]
        cell.backgroundColor = UIColor.yellow
        cell.textLabel?.textColor = UIColor.init(red: 14.0/255.0, green: 47.0/255.0, blue: 86.0/255.0, alpha: 1.0)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "sideToCat", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "sideToCat" {
               if let CategoryVC = segue.destination as? CategoryVC {
                CategoryVC.key = nameArr[index]
                   
               }
           }
       }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
