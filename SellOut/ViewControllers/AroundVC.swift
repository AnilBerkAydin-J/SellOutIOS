//
//  AroundVC.swift
//  SellOut
//
//  Created by Anil Berk Aydin on 4/27/20.
//  Copyright © 2020 Anil Berk Aydin. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import MapKit

class AroundVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var aroundToDetailButton: UIButton!
    @IBOutlet weak var aroundPriceLabel: UILabel!
    @IBOutlet weak var aroundNameLabel: UILabel!
    @IBOutlet weak var aroundImageView: UIImageView!
    @IBOutlet weak var aroundMapView: MKMapView!
    
    //var annotations = [MKPointAnnotation]()
    //var annotation = MKPointAnnotation()
    let db = Database.database().reference()
    var locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    var placeMark = CLPlacemark()
    var location2 = CLLocationCoordinate2D()
    var index2 = 0
    
    var city = ""
    var products = [CityProductModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        aroundMapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = CLLocation(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        location2 = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let region = MKCoordinateRegion(center: location2, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        aroundMapView.setRegion(region, animated: true)
        geoCoder.reverseGeocodeLocation(location) { (placeMarks, error) in
            if error == nil {
                placeMarks?.forEach({ (placeMark) in
                    self.city = placeMark.administrativeArea!
                    self.getData()
                })
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let selectedAnnotation = view.annotation as? MKPointAnnotation
        index2 = Int(selectedAnnotation!.subtitle!)!
        
        
        aroundImageView.image = products[index2].image
        aroundNameLabel.text = products[index2].productName
        aroundPriceLabel.text = String(products[index2].price)
        print(products[index2].price)
    }
    
    
    func getData(){
        print(city)
        products.removeAll(keepingCapacity: true)
        //annotations.removeAll(keepingCapacity: true)
        self.db.child("cityProducts").child(city).observeSingleEvent(of: .value) { (snapshot) in
            let array:NSArray = snapshot.children.allObjects as NSArray
            var index = 0
            for obj in array {
            
                let snapshot:DataSnapshot = obj as! DataSnapshot
                let pKey = (snapshot as AnyObject).key as String
                if let value = snapshot.value as? [String : AnyObject]{
                    let name = value["username"] as? String ?? ""
                    let productName = value["name"] as? String ?? ""
                    let price = value["price"] as? Double ?? 0.0
                    let cat = value["category"] as? String ?? ""
                    let toID = value["id"] as? String ?? ""
                    let imageUrl = value["image1"] as? String ?? "https://as1.ftcdn.net/jpg/02/71/86/48/500_F_271864847_qVuzNqkJcnIAjkL9n5OHTsNaPTLqZbpG.jpg"
                    let lat = value["lat"] as? Double ?? 0.0
                    let long = value["lon"] as? Double ?? 0.0
                    let url = URL(string: imageUrl)
                    let data = try? Data(contentsOf: url!)
                    let image = UIImage(data: data!)
                    let product = CityProductModel(name: name, pName: productName, price: price, image:image!, lat: lat, long: long, pKey: pKey, cat: cat, toID: toID)
                    self.products.append(product)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: lat as! Double, longitude: long as! Double)
                    annotation.title = productName
                    print(productName)
                    print(lat)
                    print(long)
                    annotation.subtitle = String(index)
                    //self.annotations.append(annotation)
                    self.aroundMapView.addAnnotation(annotation)
                    index = index + 1
                }
            }
            //print(self.annotations.count)
            //self.aroundMapView.addAnnotations(self.annotations as [MKAnnotation])
            //self.aroundMapView.showAnnotations(self.aroundMapView.annotations, animated: true)
            let region = MKCoordinateRegion(center: self.location2, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
            self.aroundMapView.setRegion(region, animated: true)
        }
    }
                            
    @IBAction func aroundClicked(_ sender: Any) {
        performSegue(withIdentifier: "aroundToDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "aroundToDetail" {
            if let DetailVC = segue.destination as? DetailsVC {
                DetailVC.pKey = products[index2].pKey
                DetailVC.catName = products[index2].cat
                DetailVC.toUserID = products[index2].toID
            }
        }
    }

    

}
