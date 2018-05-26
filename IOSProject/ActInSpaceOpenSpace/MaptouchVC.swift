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
import TransitionButton 

class MaptouchVC: UIViewController, CLLocationManagerDelegate, MGLMapViewDelegate {
   
    let locationManager = CLLocationManager()
    
    var isDrawingModeEnable: Bool = false
    
    var coordinates: [CLLocationCoordinate2D] = []
    
    var mapView: MGLMapView?
    
    var polyline: CustomPolyline?
    var annots: [CustomPointAnnotation] = []
    
    @IBOutlet var startButton: TransitionButton!
    
    var shape:MGLPolygon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        let url = URL(string: "mapbox://styles/mapbox/light-v9")
        var frame = CGRect(x: view.bounds.origin.x, y: view.bounds.origin.y, width: view.bounds.width, height: view.bounds.height + 50)
        
        mapView = MGLMapView(frame: frame, styleURL: url)
        if let mapView = self.mapView {
            mapView.delegate = self
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 48.858824, longitude: 2.343595), zoomLevel: 18, animated: false)
            view.addSubview(mapView)
            view.bringSubview(toFront: self.startButton)
            let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(sender:)))
            for recognizer in mapView.gestureRecognizers! where recognizer is UITapGestureRecognizer {
                singleTap.require(toFail: recognizer)
            }
            mapView.showsUserHeadingIndicator = true
            mapView.userTrackingMode = .follow
            mapView.addGestureRecognizer(singleTap)
        }
        
        self.startButton.backgroundColor = UIColor(red: 115/255, green: 178/255, blue: 244/255, alpha: 1)
        
        self.startButton.cornerRadius = 20
        
        self.startButton.spinnerColor = .white
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
     @objc @IBAction func handleMapTap(sender: UITapGestureRecognizer) {
        let tapPoint: CGPoint = sender.location(in: mapView)
        let tapCoordinate: CLLocationCoordinate2D = (mapView?.convert(tapPoint, toCoordinateFrom: nil))!
        coordinates.append(tapCoordinate)
        if(coordinates.count < 3) {
            let annot = CustomPointAnnotation(coordinate: tapCoordinate)
            annot.image = UIImage(named: "AnnotationPoint")
            
            annots.append(annot)
            self.mapView?.addAnnotation(annot)
        } else {
            self.annots.forEach { (annot) in
                self.mapView?.removeAnnotation(annot)
            }
            if let shape = self.shape {
                self.mapView?.removeAnnotation(shape)
            }
            self.shape = MGLPolygon(coordinates: &coordinates, count: UInt(coordinates.count))
            self.mapView?.addAnnotation(shape!)
        }
    }
    
    @IBAction func sendButtonHandler(_ sender: TransitionButton) {
        sender.startAnimation()
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            
            sleep(3) // 3: Do your networking task or background work here.
            
            DispatchQueue.main.async(execute: { () -> Void in
                // 4: Stop the animation, here you have three options for the `animationStyle` property:
                // .expand: useful when the task has been compeletd successfully and you want to expand the button and transit to another view controller in the completion callback
                // .shake: when you want to reflect to the user that the task did not complete successfly
                // .normal
                sender.stopAnimation(animationStyle: .expand, completion: {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "SendedAreaVC")
                    self.present(controller, animated: true, completion: nil)
                })
            })
        })
    }
    
    func mapView(_ mapView: MGLMapView, fillColorForPolygonAnnotation annotation: MGLPolygon) -> UIColor {
        return UIColor(red: 117/255, green: 115/255, blue: 244/255, alpha: 1)
    }
    
    func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        return 0.5
    }
    
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        return .white
    }
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        // Try to reuse the existing ‘pisa’ annotation image, if it exists.
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "pisa")
        
        if annotationImage == nil {
            var image = UIImage(named: "AnnotationPoint")!
            
            // The anchor point of an annotation is currently always the center. To
            // shift the anchor point to the bottom of the annotation, the image
            // asset includes transparent bottom padding equal to the original image
            // height.
            //
            // To make this padding non-interactive, we create another image object
            // with a custom alignment rect that excludes the padding.
            image = image.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: image.size.height/2, right: 0))
            
            // Initialize the ‘pisa’ annotation image with the UIImage we just loaded.
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "pisa")
        }
        
        return annotationImage
    }
}

