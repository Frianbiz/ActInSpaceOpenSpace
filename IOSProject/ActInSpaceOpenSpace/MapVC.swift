//
//  ViewController.swift
//  ActInSpaceOpenSpace
//
//  Created by lucas colomer on 25/05/2018.
//  Copyright © 2018 Frianbiz. All rights reserved.
//

import UIKit
import CoreLocation
import Mapbox

class MapVC: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    @IBOutlet var mapView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        let url = URL(string: "mapbox://styles/mapbox/light-v9")
        mapView = MGLMapView(frame: view.bounds, styleURL: url)
        if let mapView = self.mapView as? MGLMapView {
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            mapView.setCenter(CLLocationCoordinate2D(latitude: 48.858824, longitude: 2.343595), zoomLevel: 1, animated: false)
            mapView.showsUserHeadingIndicator = true
        }
        

        view.addSubview(mapView)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        if let mapView = self.mapView as? MGLMapView {
            mapView.setCenter(CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude), zoomLevel: 20, animated: false)
        }
    }
    
}

