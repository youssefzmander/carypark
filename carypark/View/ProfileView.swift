//
//  ProfileView.swift
//  Carypark
//
//  Created by Mac-Mini_2021 on 28/11/2021.
//

import Foundation
import UIKit
import FBSDKLoginKit

class ProfileView: UIViewController {

    // variables
    let token = UserDefaults.standard.string(forKey: "userToken")!
    var user : User?
    
    // iboutlets
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    // life cycle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editProfileSegue" {
            /*let controller = segue.destinationViewController as! ResultViewController
            controller.match = self.match*/
            
            let destination = segue.destination as! EditProfileView
            destination.user = user
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeProfile()
    }

    // methods
    func initializeProfile() {
        print("initializing profile")
        UserViewModel().getUserFromToken(userToken: token, completed: { success, user in
            if success {
                self.fullNameLabel.text = user?.fullName
                self.roleLabel.text = user?.role
                self.emailLabel.text = user?.email
                self.phoneLabel.text = user?.phone
            } else {
                self.present(Alert.makeAlert(titre: "Error", message: "Could not verify token"), animated: true
                )
            }
        })
    }
    
    // actions
    @IBAction func logout(_ sender: Any) {
        print("logging out")
        
        let loginManager = LoginManager()
        loginManager.logOut()
        
        UserDefaults.standard.set(nil, forKey: "userToken")
        self.performSegue(withIdentifier: "logoutSegue", sender: nil)
    }
    
    @IBAction func editProfil(_ sender: Any) {
        
        if ((UserDefaults.standard.string(forKey: "userToken")) != nil){
            UserViewModel().getUserFromToken(userToken: token, completed: { success, user in
                self.user = user
                if success {
                    self.performSegue(withIdentifier: "editProfileSegue", sender: user)
                } else {
                    self.present(Alert.makeAlert(titre: "Error", message: "Could not verify token"), animated: true
                    )
                }
            })
        }
    }
    
    @IBAction func reloadProfile(_ sender: Any) {
        initializeProfile()
    }
}
