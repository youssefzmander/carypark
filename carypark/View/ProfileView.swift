//
//  ProfileView.swift
//  Carypark
//
//  Created by Mac-Mini_2021 on 28/11/2021.
//

import Foundation
import UIKit
import FBSDKLoginKit

protocol ModalDelegate {
    func initProfileFromEdit()
}

class ProfileView: UIViewController, ModalDelegate {

    // variables
    let token = UserDefaults.standard.string(forKey: "userToken")!
    var user : User?
    
    // iboutlets
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    // protocols
    func initProfileFromEdit() {
        initializeProfile()
    }
    
    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTF.isEnabled = false
        passwordTF.isEnabled = false
        
        initializeProfile()
    }
    
    // methods
    func initializeProfile() {
        print("initializing profile")
        UserViewModel().getUserFromToken(userToken: token, completed: { success, result in
            if success {
                self.user = result
                self.fullNameTF.text = self.user?.fullName
                self.emailTF.text = self.user?.email
                self.phoneTF.text = self.user?.phone
                self.passwordTF.text = "****"
            } else {
                self.present(Alert.makeAlert(titre: "Error", message: "Could not verify token"), animated: true
                )
            }
        })
    }
    
    // actions
    @IBAction func confirmChanges(_ sender: Any) {
        
        //user?.email = emailTF.text
        user?.fullName = fullNameTF.text
        user?.phone = phoneTF.text
        
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
