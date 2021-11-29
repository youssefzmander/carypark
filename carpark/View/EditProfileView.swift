//
//  EditProfileView.swift
//  Carypark
//
//  Created by Mac-Mini_2021 on 28/11/2021.
//

import Foundation
import UIKit

class EditProfileView: UIViewController {

    // variables
    var user : User?
    
    // iboutlets
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    
    // protocols
    
    
    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTF.text = user?.email
        nameTF.text = user?.fullName
        
        emailTF.textColor = .white
        emailTF.backgroundColor = .gray
        emailTF.isEnabled = false
        
    }
    
    // methods

    // actions
    @IBAction func confirmChanges(_ sender: Any) {
        
        if /*emailTF.text!.isEmpty ||*/ nameTF.text!.isEmpty {
            self.present(Alert.makeAlert(titre: "Warning", message: "You must fill all the fields"), animated: true)
            return
        }
        
        //user?.email = emailTF.text
        user?.fullName = nameTF.text
        
        
        UserViewModel().editProfile(user: user!) { success in
            if success {
                let action = UIAlertAction(title: "Proceed", style: .default) { UIAlertAction in
                    self.dismiss(animated: true, completion: nil)
                }
                self.present(Alert.makeSingleActionAlert(titre: "Success", message: "Profile edited successfully", action: action), animated: true)
            } else {
                self.present(Alert.makeAlert(titre: "Error", message: "Could not edit your profile"), animated: true)
            }
        }
    }
    
}
