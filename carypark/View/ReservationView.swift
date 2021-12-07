//
//  ReservationView.swift
//  carypark
//
//  Created by Mac-Mini_2021 on 2/12/2021.
//

import UIKit


class ReservationView: UIViewController  {
    
    // variables
    var parking : Parking?
    
    // iboutlets
    @IBOutlet weak var parkingNameLabel: UILabel!
    @IBOutlet weak var checkInDatePicker: UIDatePicker!
    @IBOutlet weak var checkOutDatePicker: UIDatePicker!
    
    // protocols
    
    
    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parkingNameLabel.text = "Park - " + (parking?.adresse)!
    }
    
    // methods
    
    
    // actions
    @IBAction func bookSpace(_ sender: Any) {

        let reservation = Reservation(dateEntre: checkInDatePicker.date, dateSortie: checkOutDatePicker.date, parking: parking, userFromPark: (parking?.user!)!)
        
        ReservationViewModel().addReservation(reservation: reservation) { success in
            if success {
                let action = UIAlertAction(title: "Proceed", style: .default) { UIAlertAction in
                    
                    self.dismiss(animated: true, completion: nil)
                }
                self.present(Alert.makeSingleActionAlert(titre: "Success", message: "Reservation added successfully", action: action),animated: true)
            } else {
                self.present(Alert.makeAlert(titre: "Error", message: "Could not book a reservation"),animated:true)
            }
        }
    }
    
}
