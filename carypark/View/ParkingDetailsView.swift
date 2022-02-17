//
//  ParkingDetailsView.swift
//  carypark
//
//  Created by Mac-Mini_2021 on 2/12/2021.
//

import UIKit
import MapKit
import CoreLocation

class ParkingDetailsView: UIViewController  {
    
    // variables
    var parking : Parking?
    
    // iboutlets
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var availablePlacesLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    // protocols
    
    
    // life cycle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ReservationView
        destination.parking = self.parking
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adressLabel.text = parking?.adresse
        availablePlacesLabel.text = String(parking!.nbrPlace!)
        priceLabel.text = String(parking!.prix!)
    }
    
    // methods
    
    
    // actions
    @IBAction func makeReservation(_ sender: Any) {
        if parking?.nbrPlace == 0 {
            self.present(Alert.makeAlert(titre: "Warning", message: "No more places !"),animated: true)
        } else {
            performSegue(withIdentifier: "makeReservationSegue", sender: parking)
        }
    }
    
}
