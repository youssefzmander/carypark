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
    
    // protocols
    
    
    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        ModalTransitionMediator.instance.sendPopoverDismissed(modelChanged: true)
    }
    
    // methods
    
    
    // actions
    @IBAction func saveParking(_ sender: Any) {
        
        if (addressTF.text!.isEmpty || priceTF.text!.isEmpty || availablePlacesTF.text!.isEmpty){
            self.present(Alert.makeAlert(titre: "Warning", message: "You must to fill all the fields"), animated: true)
            return
        }
        
        if (Int(priceTF.text!)! < 0 ){
            self.present(Alert.makeAlert(titre: "Warning", message: "Price should be positive"), animated: true)
            return
        }
        
        parking?.adresse = addressTF.text
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
