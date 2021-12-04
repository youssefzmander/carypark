//
//  SettingsView.swift
//  carypark
//
//  Created by Mac-Mini_2021 on 1/12/2021.
//

import UIKit
import FBSDKLoginKit

class SettingsView: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logout(_ sender: Any) {
        print("logging out")
        let loginManager = LoginManager()
        loginManager.logOut()
        
        UserDefaults.standard.set(nil, forKey: "userToken")
        self.performSegue(withIdentifier: "logoutSegue", sender:nil)
    }
    
    @IBAction func parkingHistory(_ sender: Any) {
        self.tabBarController?.selectedIndex = 2
    }
}
