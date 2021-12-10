//
//  GuardianMapView.swift
//  carypark
//
//  Created by Mac-Mini_2021 on 2/12/2021.
//

import UIKit
import MapKit
import CoreLocation

class GuardianMapView: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, ModalTransitionListener {

    // variables
    let locationManager = CLLocationManager()
    var createdParking : Parking?
    var activeParking : Parking?
    let myPin = MKPointAnnotation()
    
    // iboutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var deleteParkButton: UIButton!
    @IBOutlet weak var addParkButton: UIButton!
    
    // protocols
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let pinAnnotation = view.annotation as? PinAnnotation
        
        ParkingViewModel().getParkingById(_id: pinAnnotation?.id) { success, responseParking in
            if success {
                self.activeParking = responseParking
                self.deleteParkButton.isEnabled = true
                self.addParkButton.isEnabled = false
                
                self.mapView.delegate = self
                
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
    
    // life cycle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addParkingSegue"{
            let destination = segue.destination as! AddParkingView
            destination.parking = createdParking
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ModalTransitionMediator.instance.setListener(listener: self)
        
        deleteParkButton.isEnabled = false
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
        
        
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(GuardianMapView.handleLongTap(gestureRecognizer:)))
        self.mapView.addGestureRecognizer(longTapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initializeLocations()
    }
    
    func popoverDismissed() {
        initializeLocations()
        self.deleteParkButton.isEnabled = false
        self.addParkButton.isEnabled = false
    }
    
    // methods
    func initializeLocations() {
        
        ParkingViewModel().getMyParkings{ success, parkings in
            if success {
                
                var pinAnnotations : [PinAnnotation] = []
                for parking in parkings! {
                    
                    print("Loading location with coordinates (" + String(parking.latitude!) + "," + String(parking.longitude!) + ")")
                    
                    let pinAnnotation = PinAnnotation()
                    pinAnnotation.setCoordinate(newCoordinate: CLLocationCoordinate2D(latitude: parking.latitude!, longitude: parking.longitude!))
                    pinAnnotation.title = parking.adresse
                    pinAnnotation.id = parking._id
                    
                    pinAnnotations.append(pinAnnotation)
                }
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.addAnnotations(pinAnnotations)
                
            } else {
                self.present(Alert.makeAlert(titre: "Server error", message: "Could not load locations"),animated: true)
            }
        }
    }
    
    @objc func handleLongTap(gestureRecognizer: UITapGestureRecognizer){
        
        if gestureRecognizer.state != UITapGestureRecognizer.State.ended{
            let touchLocation = gestureRecognizer.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
            
            deleteParkButton.isEnabled = false
            addParkButton.isEnabled = true
            
            print("Tapped at Lattitude: " + String(locationCoordinate.latitude) + ", Longitude: " + String(locationCoordinate.longitude))
            
            
            myPin.coordinate = locationCoordinate
            
            myPin.title = "Lattitude: " + String(locationCoordinate.latitude) + ", Longitude: " + String(locationCoordinate.longitude)
            
            createdParking = Parking(longitude: locationCoordinate.longitude, latitude: locationCoordinate.latitude)
            
            mapView.addAnnotation(myPin)
        }
    }
    
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer){
        
        if gestureRecognizer.state != UITapGestureRecognizer.State.began{
            mapView.removeAnnotation(myPin)
            deleteParkButton.isEnabled = false
            addParkButton.isEnabled = false
        }
    }
    
    // actions
    @IBAction func addParking(_ sender: Any) {
        performSegue(withIdentifier: "addParkingSegue", sender: createdParking)
    }
    
    @IBAction func deletePark(_ sender: Any) {
        self.present(Alert.makeActionAlert(titre: "Warning", message: "Are you sure you want to delete this park", action: UIAlertAction(title: "Yes", style: .destructive, handler: { [self] uiAction in
            ParkingViewModel().deleteParking(_id: activeParking?._id) { success in
                self.present(Alert.makeAlert(titre: "Success", message: "Park deleted"),animated: true)
                self.initializeLocations()
                self.deleteParkButton.isEnabled = false
                self.addParkButton.isEnabled = false
            }
        })),animated: true)
    }
}
