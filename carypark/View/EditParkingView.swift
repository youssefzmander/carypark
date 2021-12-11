//
//  AddParkingView.swift
//  carypark
//
//  Created by Mac-Mini_2021 on 3/12/2021.
//

import Foundation
import UIKit

class EditParkingView: UIViewController  {
    
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
        
        addressTF.text = parking?.adresse
        priceTF.text = String(parking!.prix!)
        availablePlacesTF.text = String(parking!.nbrPlace!)
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
        
        if Float(priceTF.text!) == nil {
            self.present(Alert.makeAlert(titre: "Warning", message: "Price should be a float"),animated: true)
            return
        }
        
        if Int(availablePlacesTF.text!) == nil {
            self.present(Alert.makeAlert(titre: "Warning", message: "Available places should be a number"),animated: true)
            return
        }
        
        if (Int(priceTF.text!)! < 0 ){
            self.present(Alert.makeAlert(titre: "Warning", message: "Price should be positive"), animated: true)
            return
        }
        
        parking?.adresse = addressTF.text
        parking?.nbrPlace = Int(availablePlacesTF.text!)
        parking?.prix = Float(priceTF.text!)
   
        ParkingViewModel().editParking(parking: parking!) { success in
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
    
    @IBAction func deletePark(_ sender: Any) {
        self.present(Alert.makeActionAlert(titre: "Warning", message: "Are you sure you want to delete this park", action: UIAlertAction(title: "Yes", style: .destructive, handler: { [self] uiAction in
            ParkingViewModel().deleteParking(_id: parking?._id) { success in
                self.present(Alert.makeAlert(titre: "Success", message: "Park deleted"),animated: true)
                self.dismiss(animated: true, completion: nil)
            }
        })),animated: true)
    }
}
