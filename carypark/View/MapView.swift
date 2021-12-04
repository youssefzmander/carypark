//
//  MapViewController.swift
//  carypark
//
//  Created by Mac-Mini_2021 on 2/12/2021.
//

import UIKit
import MapKit
import CoreLocation

class MapView: UIViewController, CLLocationManagerDelegate  {
    
    // variables
    let locationManager = CLLocationManager()
    var activeParking : Parking?
    var currentLocation : CLLocationCoordinate2D?
    
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
        
        // User location
        let noLocation = CLLocationCoordinate2D()
        
        // Esprit location
        let espritLocation = CLLocationCoordinate2D(latitude: 36.897901,longitude: 10.190886)
        
        currentLocation = espritLocation
        
        let viewRegion = MKCoordinateRegion(center: currentLocation!, latitudinalMeters: 100000, longitudinalMeters: 100000)
        mapView.setRegion(viewRegion, animated: false)
        mapView.showsUserLocation = true
        
        
        
    }
    
    // methods
    func initializeLocations() {
        
        ParkingViewModel().getAllParking { success, parkings in
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
                self.mapView.addAnnotations(pinAnnotations)
                
            } else {
                self.present(Alert.makeAlert(titre: "Server error", message: "Could not load locations"),animated: true)
            }
        }
    }
    
    func createPath(sourceLocation : CLLocationCoordinate2D, destinationLocation : CLLocationCoordinate2D) {
        let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        
        let sourceMapItem = MKMapItem(placemark: sourcePlaceMark)
        let destinationItem = MKMapItem(placemark: destinationPlaceMark)
        
        
        let sourceAnotation = MKPointAnnotation()
        sourceAnotation.title = "Source"
        sourceAnotation.subtitle = "You"
        if let location = sourcePlaceMark.location {
            sourceAnotation.coordinate = location.coordinate
        }
        
        let destinationAnotation = MKPointAnnotation()
        destinationAnotation.title = "Destination"
        destinationAnotation.subtitle = "Your car park"
        if let location = destinationPlaceMark.location {
            destinationAnotation.coordinate = location.coordinate
        }
        
        self.mapView.showAnnotations([sourceAnotation, destinationAnotation], animated: true)
        
        
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationItem
        directionRequest.transportType = .automobile
        
        let direction = MKDirections(request: directionRequest)
        
        
        direction.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("ERROR FOUND : \(error.localizedDescription)")
                }
                return
            }
            
            let route = response.routes[0]
            self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let pinAnnotation = view.annotation as? PinAnnotation
        
        ParkingViewModel().getParkingById(_id: pinAnnotation?.id) { success, responseParking in
            if success {
                self.activeParking = responseParking
                self.viewParkButton.isEnabled = true
                
                /*let sourceLocation =  CLLocationCoordinate2D(latitude: self.currentLocation!.latitude, longitude: self.currentLocation!.longitude)
                let destinationLocation = CLLocationCoordinate2D(latitude: pinAnnotation!.coordinate.latitude, longitude: pinAnnotation!.coordinate.longitude)
                */
                
                let sourceLocation = CLLocationCoordinate2D(latitude: 28.704060, longitude: 77.102493)
                let destinationLocation = CLLocationCoordinate2D(latitude: 28.459497, longitude: 77.026634)
                
                self.createPath(sourceLocation: sourceLocation, destinationLocation: destinationLocation)
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
    
    // actions
    @IBAction func viewParking(_ sender: Any) {
        performSegue(withIdentifier: "parkingDetailsSegue", sender: activeParking)
    }
}

extension MapView : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let rendere = MKPolylineRenderer(overlay: overlay)
        rendere.lineWidth = 5
        rendere.strokeColor = .systemBlue
        
        return rendere
    }
}
