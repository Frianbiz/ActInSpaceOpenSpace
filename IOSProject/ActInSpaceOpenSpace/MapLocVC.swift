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

class MapLocVC: UIViewController, CLLocationManagerDelegate, MGLMapViewDelegate {
   
    let locationManager = CLLocationManager()
    
    var isDrawingModeEnable: Bool = false
    
    var coordinates: [CLLocationCoordinate2D] = []
    
    var mapView: MGLMapView?
    
    var polyline: CustomPolyline?
    var annots: [CustomPointAnnotation] = []
    
    @IBOutlet var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        let url = URL(string: "mapbox://styles/mapbox/light-v9")
        mapView = MGLMapView(frame: view.bounds, styleURL: url)
        if let mapView = self.mapView {
            mapView.delegate = self
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 48.858824, longitude: 2.343595), zoomLevel: 20, animated: false)
            mapView.showsUserHeadingIndicator = true
            mapView.userTrackingMode = .follow
     
            view.addSubview(mapView)
            view.bringSubview(toFront: self.startButton)
        }
    }
    
    @IBAction func startDrawHandler(_ sender: Any) {
        if self.isDrawingModeEnable {
            self.isDrawingModeEnable = false
            self.annots.forEach { (annot) in
                self.mapView?.removeAnnotation(annot)
            }
            let shape = MGLPolygon(coordinates: &coordinates, count: UInt(coordinates.count))
            self.mapView?.addAnnotation(shape)
        } else {
            self.isDrawingModeEnable = true
        }
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
        print("Location : \(locValue.latitude) - \(locValue.longitude)")
            if self.isDrawingModeEnable {
                if (coordinates.contains(where: { (loc) -> Bool in
                    return loc.latitude == locValue.latitude && loc.longitude == locValue.longitude;
                })){
                    
                }
                coordinates.append(locValue)
                let annot = CustomPointAnnotation(coordinate: locValue)
                annots.append(annot)
                self.mapView?.addAnnotation(annot)
            }
    }
    
    
    func mapView(_ mapView: MGLMapView, fillColorForPolygonAnnotation annotation: MGLPolygon) -> UIColor {
        return UIColor(red: 59/255, green: 178/255, blue: 208/255, alpha: 1)
    }
    
    func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        return 0.5
    }
    
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        return .white
    }
}

