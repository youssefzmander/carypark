//
//  MapViewController.swift
//  carypark
//
//  Created by Mac-Mini_2021 on 2/12/2021.
//

import UIKit
import MapKit
import CoreLocation

class MapView: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate  {
    
    // variables
    let locationManager = CLLocationManager()
    var activeParking : Parking?
    
    // iboutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var viewParkButton: UIButton!
    
    // protocols
    
    // life cycle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "parkingDetailsSegue"{
            let destination = segue.destination as! ParkingDetailsView
            destination.parking = activeParking
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewParkButton.isEnabled = false
        
        initializeLocations()
        
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
        
    }
    
    // methods
    func initializeLocations() {
        
        ParkingViewModel().getAllParking { success, parkings in
            if success {
                
                for parking in parkings! {
                    
                    print("Loading location with coordinates (" + String(parking.latitude!) + "," + String(parking.longitude!) + ")")
                    
                    let pinAnnotation = PinAnnotation()
                    pinAnnotation.setCoordinate(newCoordinate: CLLocationCoordinate2D(latitude: parking.latitude!, longitude: parking.longitude!))
                    pinAnnotation.title = parking.adresse
                    pinAnnotation.id = parking._id
                    self.mapView.addAnnotation(pinAnnotation)
                }
            } else {
                self.present(Alert.makeAlert(titre: "Server error", message: "Could not load locations"),animated: true)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let pinAnnotation = view.annotation as? PinAnnotation
        
        ParkingViewModel().getParkingById(_id: pinAnnotation?.id) { success, responseParking in
            if success {
                self.activeParking = responseParking
                self.viewParkButton.isEnabled = true
            } else {
                self.present(Alert.makeAlert(titre: "Error", message: "Could not load parking"), animated: true)
            }
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
    @IBAction func viewParking(_ sender: Any) {
        performSegue(withIdentifier: "parkingDetailsSegue", sender: activeParking)
    }
}
