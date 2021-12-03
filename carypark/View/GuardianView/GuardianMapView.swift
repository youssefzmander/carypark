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
    
    let newPin = MKPointAnnotation()
    
    // iboutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var viewParkButton: UIButton!
    @IBOutlet weak var addParkButton: UIButton!
    
    // protocols
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapView.removeAnnotation(newPin)

        let location = locations.last! as CLLocation

        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

        //set region on the map
        mapView.setRegion(region, animated: true)

        newPin.coordinate = location.coordinate
        mapView.addAnnotation(newPin)

    }
    
    
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
        
    }
    
    // methods
  
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let pinAnnotation = view.annotation as? PinAnnotation
        
        ParkingViewModel().getParkingById(_id: pinAnnotation?.id) { success, responseParking in
            if success {
                self.createdParking = responseParking
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
    @IBAction func addParking(_ sender: Any) {
        performSegue(withIdentifier: "addParkingSegue", sender: createdParking)
    }
}
