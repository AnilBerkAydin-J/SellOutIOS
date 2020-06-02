//
//  ProfileVC.swift
//  SellOut
//
//  Created by Anil Berk Aydin on 4/20/20.
//  Copyright © 2020 Anil Berk Aydin. All rights reserved.
//

import UIKit
import Firebase


class ProfileVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var profileUsernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var profileEmailLabel: UILabel!
    
    @IBOutlet weak var againNewPassField: UITextField!
    @IBOutlet weak var newPassField: UITextField!
    @IBOutlet weak var newPassChange: UIButton!
    @IBOutlet weak var emailChange: UIButton!
    @IBOutlet weak var logoutButton1: UIButton!
    @IBOutlet weak var passMainChange: UIButton!
    @IBOutlet weak var userNameChange: UIButton!
    let db = Database.database().reference()
    var userName = ""
    var email = ""
    let userID = Auth.auth().currentUser?.uid
    let imgPicker = UIImagePickerController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isHidden = true
        newPassChange.isHidden = true
        newPassField.isHidden = true
        againNewPassField.isHidden = true
        saveButton.layer.cornerRadius = 5
        newPassChange.layer.cornerRadius = 5
        emailChange.layer.cornerRadius = 5
        logoutButton1.layer.cornerRadius = 5
        //passMainChange.layer.cornerRadius = 5
        userNameChange.layer.cornerRadius = 5
        profileImageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(choseImage(_:)))
        profileImageView.addGestureRecognizer(gesture)

        getData()
    }
    
    @objc func choseImage(_ sender: UITapGestureRecognizer) {
    
           imgPicker.delegate = self
          
           let alert = UIAlertController(title: "Resim Seçin", message: nil, preferredStyle: .actionSheet)
           alert.addAction(UIAlertAction(title: "Kamera", style: .default, handler: { _ in self.openCamera() }))
           alert.addAction(UIAlertAction(title: "Galeri", style: .default, handler: { _ in self.openGallery() }))
           alert.addAction(UIAlertAction(title: "Çıkış", style: .cancel, handler: nil))
           
           self.present(alert, animated: true, completion: nil)
           
       }
       
       func openCamera(){
           if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
               imgPicker.sourceType = .camera
               imgPicker.allowsEditing = true
               self.present(imgPicker, animated: true, completion: nil)
           }
           else{
               let alert = UIAlertController(title: "UYARI!", message: "Kameranız yok.", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
               self.present(alert, animated: true, completion: nil)
           }
       }
       
       func openGallery(){
           imgPicker.sourceType = .photoLibrary
           imgPicker.allowsEditing = true
           self.present(imgPicker, animated: true, completion: nil)
       }
       
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        profileImageView.image = info[.originalImage] as? UIImage
        saveButton.isHidden = false
           
           self.dismiss(animated: true, completion: nil)
       }
    
    
    func getData(){
        
        email = Auth.auth().currentUser?.email as! String
        self.profileEmailLabel.text = "Email: \(email)"
        let data = try? Data(contentsOf: (Auth.auth().currentUser?.photoURL)!)
        profileImageView.image = UIImage(data: data!)
        db.child("users").child(userID!).observeSingleEvent(of: .value) { (snap) in
            let value = snap.value as? NSDictionary
            self.userName = value?["username"] as! String
            self.profileUsernameLabel.text = "Kullanıcı Adı: \(self.userName)"
        }
        
        
    }
    

    @IBAction func usernameClicked(_ sender: Any) {
      
        var textField = UITextField()
         
         
         let alert = UIAlertController(title: "Kullanıcı Adı Değiştir", message: "Yeni kullanıcı adınızı giriniz.", preferredStyle: .alert)
        
        

         alert.addTextField { (textField) in
             textField.placeholder = "Yeni kullanıcı adı"
         }
        
         alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { [weak alert] (_) in
             textField = alert?.textFields![0] as! UITextField
            self.db.child("usernames").child(textField.text!).observeSingleEvent(of: .value) { (snapshot) in
                if snapshot.exists(){
                    self.makeAlert(titleInput: "Hata!", messageInput: "Bu kullanıcı adı kullanılmaktadır.")
                }else {
                    self.profileUsernameLabel.text = "Kullanıcı Adı: \(textField.text)"
                    self.db.child("users").child(self.userID!).updateChildValues(["username":textField.text!])
                    self.db.child("usernames").updateChildValues([textField.text!:self.userID!])
                    self.makeAlert(titleInput: "Başarılı", messageInput: "Kullanıcı adınız başarılı bir şekilde güncellenmiştir.")
                }
            }
         }))
         self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func passClicked(_ sender: Any) {
         
              newPassChange.isHidden = false
              newPassField.isHidden = false
              againNewPassField.isHidden = false
              
    }
    
    
    @IBAction func newPassClicked(_ sender: Any) {
        
        if self.isValidPassword(password: self.newPassField.text!){
        if self.newPassField.text! == self.againNewPassField.text! {
        
        Auth.auth().currentUser?.updatePassword(to: newPassField.text!) { (error) in
            if error != nil {
                print("Success")
                self.makeAlert(titleInput: "Başarılı!", messageInput: "Şifreniz başarılı bir şekilde güncellenmiştir.")
            }
        }
            }else {
                self.makeAlert(titleInput: "Hata!", messageInput: "İki şifrenin aynı olduğundan emin olun.")
            }
        }else {
            self.makeAlert(titleInput: "Hata!", messageInput: "Şifreniz en az 8 karakter uzunluğunda olmalı ve en az bir rakam ve harf içermelidir.")
        }
    }
    
    
    @IBAction func emailClicked(_ sender: Any) {
           var textField = UITextField()
              
              
              let alert = UIAlertController(title: "Email Değiştir", message: "Yeni email giriniz.", preferredStyle: .alert)
        
       

              alert.addTextField { (textField) in
                  textField.placeholder = "Yeni email"
              }
             
              alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { [weak alert] (_) in
                  textField = alert?.textFields![0] as! UITextField
                if self.isValidEmail(email: textField.text!) {
                Auth.auth().currentUser?.updateEmail(to: textField.text!) { (error) in
                    if error != nil {
                        print("Success")
                        self.profileEmailLabel.text = "Email: \(textField.text)"
                        self.makeAlert(titleInput: "Başarılı!", messageInput: "Emailiniz başarılı bir şekilde güncellenmiştir.")
                    }else {
                        self.makeAlert(titleInput: "Hata!", messageInput: error!.localizedDescription)
                    }
                }
                }else {
                    self.makeAlert(titleInput: "Hata!", messageInput: "Lütfen uygun bir email adresi girin.")
                }
                  
              }))
              self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        try! Auth.auth().signOut()
        let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "ViewController")
        self.present(destViewController, animated: true)
        
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageReferance = storage.reference()
        let mediaFolder = storageReferance.child("usersMedia").child(userID!).child("profilePictures")
        let uuid = UUID()
        let imageReferance = mediaFolder.child("\(uuid).jpg")
        if let data = self.profileImageView.image?.jpegData(compressionQuality: 0.5) {
            print("girdimi1")
            imageReferance.putData(data, metadata: nil) { (metadata, error) in
                print("girdimi2")
                if error == nil {
                    print("girdimi3")
                    imageReferance.downloadURL { (url, error) in
                        print("girdimi4")
                           if error == nil {
                            print("girdimi5")
                            let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
                            changeRequest.photoURL = url
                            changeRequest.commitChanges { error in
                                print("girdimi6")
                                if error == nil {
                                     print("success")
                                    self.db.child("users").child(self.userID!).updateChildValues(["photoUrl": url?.absoluteString])
                                    self.makeAlert(titleInput: "Başarılı!", messageInput: "Resminiz başarılı bir şekilde güncellenmiştir.")
                                    }
                            }
                        }
                    }
                }else {
                    print(error?.localizedDescription)
                }
            }
        }
    }
    
    func isValidPassword(password: String) -> Bool {
           let passRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
           let passPred = NSPredicate(format: "SELF MATCHES %@", passRegex)
           return passPred.evaluate(with: password)
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z09.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPred.evaluate(with: email)
    }
    
    func makeAlert(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okBt = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okBt)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
}
