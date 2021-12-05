//
//  AddParkingView.swift
//  carypark
//
//  Created by Mac-Mini_2021 on 3/12/2021.
//

import Foundation
import UIKit

class AddParkingView: UIViewController  {
    // variables
    var parking : Parking?
    
    // iboutlets
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var availablePlacesTF: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    
    // protocols
    
    
    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(parking)
    }
    
    // methods
    
    
    // actions
    @IBAction func saveParking(_ sender: Any) {
        
        parking?.adresse = addressTF.text
        parking?.idUser = ""
        parking?.nbrPlace = Int(availablePlacesTF.text!)
        parking?.prix = Float(priceTF.text!)
        
        ParkingViewModel().addParking(parking: parking!) { success in
            if success {
                let action = UIAlertAction(title: "Proceed", style: .default, handler: { uiAlertAction in
                    self.dismiss(animated: true, completion: nil)
                })
                self.present(Alert.makeSingleActionAlert(titre: "Success", message: "Parking added successfully", action: action), animated: true)
            } else {
                self.present(Alert.makeAlert(titre: "Error", message: "Could not be added"), animated: true)
            }
        }
    }
    
}
