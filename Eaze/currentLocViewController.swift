//
//  currentLocViewController.swift
//  Eaze
//
//  Created by Jerry Shi on 1/19/17.
//  Copyright © 2017 easeapp. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class currentLocViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var currentMapView: MKMapView!
    
    @IBOutlet var currentLat: UILabel!
    
    @IBOutlet var currentLon: UILabel!
    
    @IBOutlet var currentStreet: UILabel!
    
    var setlocationName: String = ""
    var setstreet: String = ""
    var setcity: String = ""
    var setzip: String = ""
    var setcountry: String = ""
    
    let currentLocManager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        currentMapView.setRegion(region, animated: true)
        
        self.currentMapView.showsUserLocation = true
        
        self.currentLat.text = String(location.coordinate.latitude)
        self.currentLon.text = String(location.coordinate.longitude)
        
        let geoCoder = CLGeocoder()
        let geoLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        geoCoder.reverseGeocodeLocation(geoLocation, completionHandler: { (placemarks, error) -> Void in
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                print(locationName)
                self.setlocationName = locationName as String
            }
            if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
                print(street)
                self.setstreet = street as String
            }
            if let city = placeMark.addressDictionary!["City"] as? NSString {
                print(city)
                self.setcity = city as String
            }
            if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
                print(zip)
                self.setzip = zip as String
            }
            if let country = placeMark.addressDictionary!["Country"] as? NSString {
                print(country)
                self.setcountry = country as String
            }
        })
        
        self.currentStreet.text = "\(setlocationName), \(setstreet), \(setcity), \(setzip), \(setcountry)"
    }
    
    func setupCurrentLocation () {
        currentLocManager.delegate = self
        currentLocManager.desiredAccuracy = kCLLocationAccuracyBest
        currentLocManager.requestWhenInUseAuthorization()
        currentLocManager.startUpdatingLocation()
    }

    
    
    override func viewDidLoad() {
        setupCurrentLocation()
    }
    
}
