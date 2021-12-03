//
//  GuardianProfileView.swift
//  carypark
//
//  Created by Mac-Mini_2021 on 3/12/2021.
//

import Foundation
import UIKit
import FBSDKLoginKit

class GuardianProfileView: UIViewController  {
    // variables
    
    // iboutlets

    // protocols
    
    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // methods
    
    
    // actions
    @IBAction func logout(_ sender: Any) {
        print("logging out")
        
        let loginManager = LoginManager()
        loginManager.logOut()
        
        UserDefaults.standard.set(nil, forKey: "userToken")
        self.performSegue(withIdentifier: "logoutSegue", sender:nil)
    }
}
