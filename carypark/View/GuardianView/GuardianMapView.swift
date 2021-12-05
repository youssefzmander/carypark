//
//  GuardianMapView.swift
//  carypark
//
//  Created by Mac-Mini_2021 on 2/12/2021.
//

import UIKit
import MapKit
import CoreLocation

class GuardianMapView: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate  {
    
    // variables
    let locationManager = CLLocationManager()
    var createdParking : Parking?
    let myPin = MKPointAnnotation()
    
    // iboutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var viewParkButton: UIButton!
    @IBOutlet weak var addParkButton: UIButton!
    
    // protocols
    
    // life cycle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addParkingSegue"{
            let destination = segue.destination as! AddParkingView
            destination.parking = createdParking
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewParkButton.isEnabled = false
        addParkButton.isEnabled = false
        
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(GuardianMapView.handleTap(gestureRecognizer:)))
        self.mapView.addGestureRecognizer(tapGesture)
    }
    
    // methods
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer){
        
        if gestureRecognizer.state != UITapGestureRecognizer.State.began{
            let touchLocation = gestureRecognizer.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
            
            addParkButton.isEnabled = true
            
            print("Tapped at Lattitude: " + String(locationCoordinate.latitude) + ", Longitude: " + String(locationCoordinate.longitude))
            
            
            myPin.coordinate = locationCoordinate
            
            myPin.title = "Lattitude: " + String(locationCoordinate.latitude) + ", Longitude: " + String(locationCoordinate.longitude)
            
            createdParking = Parking(longitude: locationCoordinate.longitude, latitude: locationCoordinate.latitude)
            
            mapView.addAnnotation(myPin)
        }
    }
    
    internal func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is PinAnnotation {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "")
            
            pinAnnotationView.tintColor = UIColor(named: "accentColor")
            pinAnnotationView.isDraggable = true
            pinAnnotationView.canShowCallout = true
            pinAnnotationView.animatesDrop = true
            
            return pinAnnotationView
        }
        
        return nil
    }
    
    internal func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? PinAnnotation {
            mapView.removeAnnotation(annotation)
        }
    }
    
    // actions
    @IBAction func addParking(_ sender: Any) {
        performSegue(withIdentifier: "addParkingSegue", sender: createdParking)
    }
}
