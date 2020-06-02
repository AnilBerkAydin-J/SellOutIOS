//
//  MessageListVC.swift
//  SellOut
//
//  Created by Anil Berk Aydin on 5/7/20.
//  Copyright © 2020 Anil Berk Aydin. All rights reserved.
//

import UIKit
import Firebase

class MessageListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    

    @IBOutlet weak var messageListTableView: UITableView!
    
    let db = Database.database().reference()
    var users = [MessageListModel]()
    var toUser = ""
    var username = ""
    var userIds = [String]()
    let userID = Auth.auth().currentUser?.uid
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messageListTableView.delegate = self
        messageListTableView.dataSource = self
        
        getList()
    }
    
    func getList(){
       
        users.removeAll(keepingCapacity: false)
        let group = DispatchGroup()
        let query = db.child("messages").child(userID!)
        group.enter()
        query.observe(DataEventType.value, with: { (snapshot) in
            let array:NSArray = snapshot.children.allObjects as NSArray
            print("listgirdimi 1")
            for obj in array {
               print("deneme1")
                print("listgirdimi 2")
            let snapshot:DataSnapshot = obj as! DataSnapshot
                
                self.userIds.append(snapshot.key)
            print(self.userIds)
                
               
            }
            group.leave()
        })
        group.notify(queue: .main){
            for userID in self.userIds {
                self.getLastMessage(toUser: userID)
            }
        }
        
    }
    
    func getLastMessage(toUser:String){
        self.db.child("users").child(toUser).observeSingleEvent(of: DataEventType.value) { (snapshot) in
           
            let value = snapshot.value as? NSDictionary
            print("listgirdimi 3")
            self.username = value?["username"] as? String ?? ""
            let photoUrl = value?["photoUrl"] as? String ?? ""
            print(photoUrl)
            
            self.db.child("messages").child(self.userID!).child(toUser).queryLimited(toLast: 1).observeSingleEvent(of: DataEventType.value) { (snapshot) in
               
                print(snapshot)
                print("listgirdimi 4")
                let array:NSArray = snapshot.children.allObjects as NSArray
                
               
                for obj in array {
                    
                    print("listgirdimi 5")
                    print("OBJECTTTTTTT\(obj)")
                    let snapshot:DataSnapshot = obj as! DataSnapshot
                    print("SNAPSHOTTTTTT\(snapshot)")
                    let value2 = snapshot.value as? [String : AnyObject]
                    let text = value2?["message"] as? String ?? ""
                    let user = MessageListModel(text: text, name: self.username, imageUrl: photoUrl)
                    print(user)
                    self.users.append(user)
                    self.messageListTableView.reloadData()
                    
                }
                
            }
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableCell", for: indexPath) as! MessageTableCell
        cell.messageTableNameLabel.text = users[indexPath.row].name
        cell.messageTableTextLabel.text = users[indexPath.row].text
        let url = URL(string: users[indexPath.row].imageUrl)
        let data = try? Data(contentsOf: url!)
        let image = UIImage(data: data!)
        cell.messageTableImageView.image = image
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "messagesToMessageVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "messagesToMessageVC" {
            if let MessageVC = segue.destination as? MessageVC {
                MessageVC.toUserID = userIds[index]
                MessageVC.toUserName = users[index].name
            }
        }
    }

}
