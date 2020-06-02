//
//  MessageVC.swift
//  SellOut
//
//  Created by Anil Berk Aydin on 4/30/20.
//  Copyright © 2020 Anil Berk Aydin. All rights reserved.
//

import UIKit
import Firebase

class MessageVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var messageCollectionView: UICollectionView!
    
    var toUserID = ""
    let fromUserID = Auth.auth().currentUser?.uid
    let db = Database.database().reference()
    var messages = [MessageModel]()
    var toUserName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        sendButton.layer.cornerRadius = 7
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.yellow]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.title = toUserName
        
        messageCollectionView.register(MessageCollectionViewCell.self, forCellWithReuseIdentifier: "messageCollectionViewCell")
        messageCollectionView.delegate = self
        messageCollectionView.dataSource = self
        messageCollectionView.backgroundColor = .white
        messageCollectionView.alwaysBounceVertical = true
        
        
        // Do any additional setup after loading the view.
        getMessages()
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sendButton.becomeFirstResponder()
    }
    
    func getMessages(){
        messages.removeAll(keepingCapacity: false)
        let query = db.child("messages").child(fromUserID!).child(toUserID)
        
        query.observe(.childAdded, with: {(snapshot) in
            let text = snapshot.childSnapshot(forPath: "message").value as? String ?? ""
            let toID = snapshot.childSnapshot(forPath: "toID").value as? String ?? ""
            let fromID = snapshot.childSnapshot(forPath: "fromID").value as? String ?? ""
            let message = MessageModel(text: text,toID: toID, fromID: fromID)
            self.messages.append(message)
            self.messageCollectionView.reloadData()
            if self.messages.count > 0 {
                self.messageCollectionView.scrollToItem(at: IndexPath(item: self.messages.count-1, section: 0), at: .bottom, animated: true)
            }
        })
        
    }
  
    @IBAction func sendClicked(_ sender: Any) {
        
        guard let key = self.db.child("messages").child(fromUserID!).child(toUserID).childByAutoId().key else {return}
        if messageField.text != "" {
            let message = messageField.text
            let now = Date()
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "dd-MM-yyyy HH:mm O"
            let dateString = formatter.string(from: now)
            print(dateString)
            let post = ["message": message, "fromID": fromUserID, "toID": toUserID, "timestamp": dateString, "read": 0] as [String:Any]
            
            self.db.child("messages").child(fromUserID!).child(toUserID).child(key).setValue(post){ (error:Error?, ref:DatabaseReference) in
                if let error = error {
                    print("Data could not be saved: \(error).")
                } else {
                    print("Data saved successfully!")
                }
            }
            self.db.child("messages").child(toUserID).child(fromUserID!).child(key).setValue(post){ (error:Error?, ref:DatabaseReference) in
                if let error = error {
                    print("Data could not be saved: \(error).")
                } else {
                    print("Data saved successfully!")
                }
            }
        }
        messageField.text = ""
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "messageCollectionViewCell", for: indexPath) as! MessageCollectionViewCell
        
        
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        var estimatedFrame = NSString(string: messages[indexPath.row].text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
        estimatedFrame.size.height += 18
        
        if messages[indexPath.row].fromID != fromUserID{
            cell.bubbleContainer.backgroundColor = .systemPurple
            cell.textView.textAlignment = .left
            cell.textView.text = messages[indexPath.row].text
            cell.textView.frame = CGRect(x: 12, y: 4, width: estimatedFrame.width + 12, height: estimatedFrame.height + 10)
            cell.bubbleContainer.frame = CGRect(x: 12, y: 4, width: estimatedFrame.width + 30, height: estimatedFrame.height + 16)
        }else {
            cell.bubbleContainer.backgroundColor = .systemGray
            cell.bubbleContainer.frame = CGRect(x: view.frame.width - estimatedFrame.width - 42, y: 4, width: estimatedFrame.width + 30, height: estimatedFrame.height + 16)
            cell.textView.textAlignment = .right
            cell.textView.text = messages[indexPath.row].text
            cell.textView.frame = CGRect(x: 10, y: 4, width: estimatedFrame.width + 12, height: estimatedFrame.height + 10)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return CGSize(width: view.frame.width, height: 50)
   }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}
