//
//  UploadVC.swift
//  SellOut
//
//  Created by Anil Berk Aydin on 4/10/20.
//  Copyright © 2020 Anil Berk Aydin. All rights reserved.
//

import UIKit
import iOSDropDown
import Firebase
import FirebaseStorage
import CoreLocation

class UploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var adresLabel: UILabel!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var dropDown: DropDown!
    
    let db = Database.database().reference()
    
    let imgPicker = UIImagePickerController()
    
    var selectedTag = 0
    var selectedCat = ""
    
    let date = Date()
    let formatter = DateFormatter()
    
    var locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    var placeMark = CLPlacemark()
    var lat = 0.0
    var long = 0.0
    var city = ""
    var adressString : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        dropDown.optionArray = ["Emlak", "Araba", "Elektronik", "Cep Telefonu", "Spor", "Eğlence", "Film, Müzik, Kitap", "Moda ve Aksesuar", "Bebek", "Giyim", "Mutfak", "Beyaz Eşya"]
        
        dropDown.didSelect {(selectedText, index, id) in
            self.selectedCat = selectedText
        }
        
        imageView1.isUserInteractionEnabled = true
        imageView2.isUserInteractionEnabled = true
        imageView3.isUserInteractionEnabled = true
        imageView4.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(choseImage(_:)))
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(choseImage(_:)))
        let gesture3 = UITapGestureRecognizer(target: self, action: #selector(choseImage(_:)))
        let gesture4 = UITapGestureRecognizer(target: self, action: #selector(choseImage(_:)))
        imageView1.addGestureRecognizer(gesture)
        imageView2.addGestureRecognizer(gesture2)
        imageView3.addGestureRecognizer(gesture3)
        imageView4.addGestureRecognizer(gesture4)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        lat = locations[0].coordinate.latitude
        long = locations[0].coordinate.longitude
        let location = CLLocation(latitude: lat, longitude: long)
        geoCoder.reverseGeocodeLocation(location) { (placeMarks, error) in
            if error == nil {
                placeMarks?.forEach({ (placeMark) in
                    
                    if let mah = placeMark.subLocality {
                        self.adressString = self.adressString + mah + ", "
                    }
                    if let sok = placeMark.thoroughfare {
                        self.adressString = self.adressString + sok + ", "
                        print(sok)
                    }
                    if let no = placeMark.subThoroughfare {
                        self.adressString = self.adressString + "No: \(no)" + ", "
                    }
                    if let subCity = placeMark.subAdministrativeArea {
                        self.adressString = self.adressString + subCity + "/"
                    }
                    if let city2 = placeMark.administrativeArea {
                        self.adressString = self.adressString + city2 + ", "
                        self.city = city2
                    }
                    if let postCode = placeMark.postalCode {
                        self.adressString = self.adressString + postCode + " "
                    }
                    self.adresLabel.text = self.adressString
                
                })
            }
        }
        print(lat)
        print(long)
    }
    
    @objc func choseImage(_ sender: UITapGestureRecognizer) {
        
        if sender.view?.tag == 1 {
            selectedTag = 1
        } else if sender.view?.tag == 2 {
           selectedTag = 2
        } else if sender.view?.tag == 3 {
            selectedTag = 3
        } else{
            selectedTag = 4
        }

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
            if selectedTag == 1 {
                imageView1.image = info[.originalImage] as? UIImage
                
            } else if selectedTag == 2{
                imageView2.image = info[.originalImage] as? UIImage
                
            } else if selectedTag == 3{
                imageView3.image = info[.originalImage] as? UIImage
            } else {
                imageView4.image = info[.originalImage] as? UIImage
            }
               
               self.dismiss(animated: true, completion: nil)
           }
    
    
    @IBAction func saveButton(_ sender: Any) {
        let group = DispatchGroup()
        
           
        if productName.text != "" && commentField.text != "" {
            if imageView1.image != UIImage(named: "Unknown-4") || imageView2.image != UIImage(named: "Unknown-4") || imageView3.image != UIImage(named: "Unknown-4") || imageView4.image != UIImage(named: "Unknown-4"){
            formatter.dateFormat = "dd.MM.yyyy"
            let res = formatter.string(from: date)
            let userID = Auth.auth().currentUser?.uid
            let storage = Storage.storage()
            let storageReferance = storage.reference()
            
           
            var imageUrl = ""
            var imageUrl2 = ""
            var imageUrl3 = ""
            var imageUrl4 = ""
            var username = ""
            guard let key = db.child("categories").child(self.selectedCat).childByAutoId().key else {return}
            let mediaFolder = storageReferance.child("usersMedia").child(userID!).child(key)
        
            
            
            self.db.child("users").child(userID!).observeSingleEvent(of: .value) { (snapshot) in
                let value = snapshot.value as? NSDictionary
                username = value?["username"] as! String
                print(username)
                
                    group.enter()
                    if self.imageView1.image != UIImage(named: "Unknown-4"){
                if let data = self.imageView1.image?.jpegData(compressionQuality: 0.5) {
                           print("GİRDİMİ1")
                    let imageReferance = mediaFolder.child("\(key)_1.jpg")
                           
                           imageReferance.putData(data, metadata: nil) { (metadata, error) in
                               if error != nil {
                                   self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                               }else{
                                   imageReferance.downloadURL { (url, error) in
                                       if error == nil {
                                        imageUrl = url?.absoluteString as! String
                                        print(imageUrl)
                                        group.leave()
                                        
                                    }
                                }
                            }
                    }
                    print("ÇIKTIMI")
                }
                }
                    group.enter()
                    if self.imageView2.image != UIImage(named: "Unknown-4"){
                if let data2 = self.imageView2.image?.jpegData(compressionQuality: 0.5) {
                           
                           let imageReferance = mediaFolder.child("\(key)_2.jpg")
                           
                           imageReferance.putData(data2, metadata: nil) { (metadata, error) in
                               if error != nil {
                                   self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                               }else{
                                   imageReferance.downloadURL { (url, error) in
                                       if error == nil {
                                        imageUrl2 = url?.absoluteString as! String
                                        group.leave()
                                    }
                                }
                            }
                    }
                }
                    }
                    group.enter()
                    if self.imageView3.image != UIImage(named: "Unknown-4"){
                if let data3 = self.imageView3.image?.jpegData(compressionQuality: 0.5) {
                           
                           let imageReferance = mediaFolder.child("\(key)_3.jpg")
                           
                           imageReferance.putData(data3, metadata: nil) { (metadata, error) in
                               if error != nil {
                                   self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                               }else{
                                   imageReferance.downloadURL { (url, error) in
                                       if error == nil {
                                        imageUrl3 = url?.absoluteString as! String
                                        group.leave()
                                    }
                                }
                            }
                    }
                }
                    }
                    group.enter()
                    if self.imageView4.image != UIImage(named: "Unknown-4"){
                if let data4 = self.imageView4.image?.jpegData(compressionQuality: 0.5) {
                           
                           let imageReferance = mediaFolder.child("\(key)_4.jpg")
                           
                           imageReferance.putData(data4, metadata: nil) { (metadata, error) in
                               if error != nil {
                                   self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                               }else{
                                   imageReferance.downloadURL { (url, error) in
                                       if error == nil {
                                        imageUrl4 = url?.absoluteString as! String
                                        group.leave()
                                    }
                                }
                            }
                    }
                }
                    }
                    
                    group.notify(queue: .main){
                        
                        let post = ["name": self.productName.text!,"category": self.selectedCat,"price": Double(self.priceField.text!),"date": res, "comment": self.commentField.text!, "adress": self.adressString,"status": "0", "image1":imageUrl, "image2":imageUrl2, "image3":imageUrl3, "image4":imageUrl4, "lat": self.lat, "lon": self.long, "city": self.city, "toID": userID] as [String : Any]
                        
                        let post2 = ["name": self.productName.text!,"category": self.selectedCat,"price": Double(self.priceField.text!),"date": res, "comment": self.commentField.text!, "adress": self.adressString,"status": "0", "image1":imageUrl, "image2":imageUrl2, "image3":imageUrl3, "image4":imageUrl4, "lat": self.lat, "lon": self.long, "city": self.city, "userID": userID, "id": userID] as [String : Any]
                        
                        let post3 = ["name": self.productName.text!, "image1":imageUrl, "lat": self.lat, "lon": self.long, "city": self.city, "price": Double(self.priceField.text!), "userID": userID, "category": self.selectedCat] as [String:Any]
                print(post)
                self.db.child("categories").child(self.selectedCat).child(key).setValue(post){
                    (error:Error?, ref:DatabaseReference) in
                    if let error = error {
                        print("Data could not be saved: \(error).")
                    } else {
                   
                        print("Data saved successfully!")
                    }
                }
                        self.db.child("cityProducts").child(self.city).child(key).setValue(post3) {
                            (error:Error?, ref:DatabaseReference) in
                             if let error = error {
                                 print("Data could not be saved: \(error).")
                             } else {
                            
                                 print("Data saved successfully!")
                             }
                        }
                    self.db.child("usersProducts").child(userID!).child(key).setValue(post2){
                        (error:Error?, ref:DatabaseReference) in
                        if let error = error {
                            print("Data could not be saved: \(error).")
                        } else {
                                      
                            print("Data saved successfully!")
                            self.makeAlert(titleInput: "Başarılı!", messageInput: "Ürününüz başarılı bir şekilde kayıt edilmiştir.")
                            }
                        }
                    }
        }
            }else {
                makeAlert(titleInput: "Hata!", messageInput: "Lütfen en az bir adet resim seçin.")
            }
        } else {
            makeAlert(titleInput: "Hata!", messageInput: "Lütfen tüm boşlukları doldurun.")
        }
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}
