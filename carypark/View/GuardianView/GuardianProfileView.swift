//
//  GuardianProfileView.swift
//  carypark
//
//  Created by Mac-Mini_2021 on 3/12/2021.
//

import Foundation
import UIKit
import FBSDKLoginKit

class GuardianProfileView: UIViewController, SecondModalTransitionListener  {

    
    // variables
    
    
    // iboutlets
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var imageUser: UIImageView!
    
    // protocols
    
    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        SecondModalTransitionMediator.instance.setListener(listener: self)
        initializeProfile()
    }
    
    func popoverDismissed() {
        initializeProfile()
    }
    
    
    // methods
    func initializeProfile(){
        UserViewModel().getUserFromToken(userToken: UserDefaults.standard.string(forKey: "userToken")!) { [self] success, user in
            profileName.text = user?.fullName
            
            let url = "http://localhost:3000/img/"+(user?.photo)!
            print(url)
            if user?.photo != nil {
                ImageLoader.shared.loadImage(identifier:(user?.photo)!, url: url, completion: {image in
                    print(url)
                    imageUser.image = image
                                
                })
            }
        }
    }
    
    // actions
    @IBAction func logout(_ sender: Any) {
        print("logging out")
        
        let loginManager = LoginManager()
        loginManager.logOut()
        
        UserDefaults.standard.set(nil, forKey: "userToken")
        self.performSegue(withIdentifier: "logoutSegue", sender:nil)
    }
    
    @IBAction func incomingRides(_ sender: Any) {
        self.tabBarController?.selectedIndex = 2
    }
    
    @IBAction func parkingHistory(_ sender: Any) {
        self.tabBarController?.selectedIndex = 3
    }
}
