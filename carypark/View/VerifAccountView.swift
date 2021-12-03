//
//  LaunchScreenView.swift
//  Carypark
//
//  Created by Mac-Mini_2021 on 28/11/2021.
//

import Foundation
import UIKit
import FBSDKLoginKit

class VerifAccountView: UIViewController {
    
    // variables
    var user : User?
    
    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let loginManager = LoginManager()
        loginManager.logOut()
        
        checkUser()
    }
    
    func checkUser(){
        
        let token = UserDefaults.standard.string(forKey: "userToken")
        
        if token != nil {
            UserViewModel().getUserFromToken(userToken: token!) { success, user in
                if success {
                    if (user!.role == "ParkOwner") {
                        self.performSegue(withIdentifier: "logInAsSecurityGuardSegue", sender: nil)
                    } else if (user!.role == "NormalUser") {
                        self.performSegue(withIdentifier: "logInAsNormalUserSegue", sender: nil)
                    }
                } else {
                    self.performSegue(withIdentifier: "notLoggedInSegue", sender: nil)
                }
            }
        } else {
            self.performSegue(withIdentifier: "notLoggedInSegue", sender: nil)
        }
    }
}
