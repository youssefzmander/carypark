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
    var delegate: ModalDelegate? 
    var user : User?
    
    // iboutlets
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    // protocols
    
    
    // life cycle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ProfileView
        destination.user = user
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTF.text = user?.email
        nameTF.text = user?.fullName
        phoneTF.text = user?.phone
        
        emailTF.isEnabled = false
        passwordTF.isEnabled = false
    }
    
    // methods
    
  
    
}
