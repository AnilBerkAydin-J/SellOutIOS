//
//  RegisterVC.swift
//  SellOut
//
//  Created by Anil Berk Aydin on 4/2/20.
//  Copyright © 2020 Anil Berk Aydin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RegisterVC: UIViewController {

  
   
    @IBOutlet weak var userNameField: DesignableUITextField!
    @IBOutlet weak var againPassField: UITextField!
    @IBOutlet weak var passField: UITextField!
    
    @IBOutlet weak var epostaField: DesignableUITextField!
    
    var db = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignBackground()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        bottomFrame(textField: userNameField)
        bottomFrame(textField: epostaField)
        bottomFrame(textField: passField)
        bottomFrame(textField: againPassField)

        
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func bottomFrame(textField: UITextField){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: textField.frame.height+3, width: textField.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.gray.cgColor
        textField.borderStyle = UITextField.BorderStyle.none
        textField.layer.addSublayer(bottomLine)
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
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func registerButton(_ sender: Any) {
        
        if userNameField.text != "" && epostaField.text != "" && passField.text != "" && againPassField.text != ""{
            print(userNameField.text!)
            db.child("usernames").child(self.userNameField.text!).observeSingleEvent(of: .value) { (snapshot) in
                if snapshot.exists(){
                    self.makeAlert(titleInput: "Hata!", messageInput: "Girmiş olduğunuz kullanıcı adı kayıtlıdır. Lütfen farklı bir kulanıcı adı girin.")
                }else {
                    if self.isValidEmail(email: self.epostaField.text!) {
                        if self.isValidPassword(password: self.passField.text!){
                            if self.passField.text! == self.againPassField.text! {
                                
                                Auth.auth().createUser(withEmail: self.epostaField.text!, password: self.passField.text!) { (authResult, error) in
                                    if error == nil {
                                        let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
                                        
                                        changeRequest.photoURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/sellout-bda2b.appspot.com/o/profilePictures?alt=media&token=17dbfe5a-866a-4bf9-baac-081b730009ad")
                                        
                                        changeRequest.commitChanges { error in
                                            if error == nil {
                                                 print("success")
                                                }
                                        }
                                        let userUid = authResult?.user.uid
                                        self.createDB(userUid: userUid!)
                                        self.db.child("usernames/\(self.userNameField.text!)").setValue(userUid)
                                    }else {
                                        print(error?.localizedDescription)
                                        self.makeAlert(titleInput: "Hata!", messageInput: error!.localizedDescription)
                                    }
                                }
                            }else {
                                self.makeAlert(titleInput: "Hata!", messageInput: "İki şifrenin aynı olduğundan emin olun.")
                            }
                        }else {
                            self.makeAlert(titleInput: "Hata!", messageInput: "Şifreniz en az 8 karakter uzunluğunda olmalı ve en az bir rakam ve harf içermelidir.")
                        }
                    }else {
                        self.makeAlert(titleInput: "Hata!", messageInput: "Lütfen uygun bir email adresi girin.")
                    }
                }
            }
        }else {
            makeAlert(titleInput: "Hata!", messageInput: "Lütfen tüm boşlukları doldurun.")
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
    
    func createDB(userUid: String) {
       let photoUrlStr = "https://firebasestorage.googleapis.com/v0/b/sellout-bda2b.appspot.com/o/profilePictures?alt=media&token=17dbfe5a-866a-4bf9-baac-081b730009ad"
        self.db.child("users").child(userUid).setValue(["username": userNameField.text!, "email": epostaField.text!, "photoUrl": photoUrlStr]) {
            (error:Error?, ref:DatabaseReference) in
                if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
                self.makeAlert(titleInput: "Kayıt Başarılı", messageInput: "Giriş sayfasına dönüp giriş yapabilirsiniz.")
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
