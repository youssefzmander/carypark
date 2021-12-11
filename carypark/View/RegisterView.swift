//
//  RegisterView.swift
//  Carypark
//
//  Created by Mac-Mini_2021 on 25/11/2021.
//

import UIKit

class RegisterView: UIViewController {
    
    // variables
    let spinner = SpinnerViewController()
    var emailToLogin: String?
    
    // iboutlets
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var carNumberTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordConfirmationTF: UITextField!
    @IBOutlet weak var roleSwitch: UISwitch!
    
    // protocols
    
    // life cycle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! LoginView
        destination.email = emailToLogin
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // methods
    func startSpinner() {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    func stopSpinner() {
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
    }
    
    func signUp(user: User){
        
        UserViewModel().signUp(user: user, completed: { (success) in
            if success {
                let action = UIAlertAction(title: "Proceed", style: .default) { UIAlertAction in
                    
                    self.performSegue(withIdentifier: "redirectToLogin", sender: user.email)
                }
                self.present(Alert.makeSingleActionAlert(titre: "Notice", message: "Inscription as a " + user.role! + " successful, a confirmation email has been sent to " + user.email! + ", please open it and click on the link.", action: action),animated: true)
            } else {
                self.present(Alert.makeAlert(titre: "Error", message: "Registration failed, email elready registered"), animated: true)
            }
        })
    }
    
    // actions
    @IBAction func register(_ sender: Any) {
        
        if (fullNameTF.text!.isEmpty || emailTF.text!.isEmpty || passwordTF.text!.isEmpty || passwordConfirmationTF.text!.isEmpty || carNumberTF.text!.isEmpty){
            self.present(Alert.makeAlert(titre: "Warning", message: "You must to fill all the fields"), animated: true)
            return
        }
        
        if (emailTF.text?.contains("@") == false){
            self.present(Alert.makeAlert(titre: "Warning", message: "Please type your email correctly"), animated: true)
        }
        
        if (passwordTF.text!.count < 8 ){
            self.present(Alert.makeAlert(titre: "Warning", message: "Password should be have at least 8 characters"), animated: true)
            return
        }
        
        if (!NSPredicate(format:"SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: passwordTF.text!)){
            self.present(Alert.makeAlert(titre: "Warning", message: "Password should have at least one capital letter"), animated: true)
            return
        }
        
        if (passwordTF.text != passwordConfirmationTF.text){
            self.present(Alert.makeAlert(titre: "Warning", message: "Password and confirmation don't match"), animated: true)
            return
        }
        
        let fullName = fullNameTF.text
        let email = emailTF.text
        let password = passwordTF.text
        
        let role: String
        if roleSwitch.isOn {
            role = "ParkOwner"
        } else {
            role = "NormalUser"
        }
        
        let user = User(fullName: fullName, email: email, password: password, cin: "", car: "", address: "", phone: "", role: role, isVerified: false)
        
        self.signUp(user: user)
    }
    
    @IBAction func redirectToLogin(_ sender: Any) {
        self.performSegue(withIdentifier: "redirectToLogin", sender: nil)
    }
}
