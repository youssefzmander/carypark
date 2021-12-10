//
//  ReservationView.swift
//  carypark
//
//  Created by Mac-Mini_2021 on 2/12/2021.
//

import UIKit
import Braintree


class ReservationView: UIViewController {

    
    
    // Paypal account
    /// carypark.app@gmail.com
    /// carypark-cred123
    
    // Braintree account
    /// email :
    /// password : Carypark-cred123
    
    // Braintree merchand account
    /// Merchand ID : vg22v8n96nzczksp
    /// Public key : s5pbrk33m67ffhq2
    /// Private key : 9b43cb14b1a2e1b41c809be66c75fdc7
    
    // Paypal sandbox seller account
    /// email : sb-8smem9008157@business.example.com
    /// password : 1OHQ5y^Z
    /// client ID : AbB9MJE1EGgQND-U1S-RVblB4Bkq460O0jUXVTwRCefrMC8Qn1B4pxFIaFR5_HxUEiRPsy5BnUl3JXsM
    /// secret : EBL5LdsEDkKaJBC9xkTi8kV6WMVkVdExgGCVfdf6ja42c9R8LF-wIWAx52-3vKDG-tfbNvpYpYJ8RGqA
    /// tokenation key : sandbox_bn3zhb5z_vg22v8n96nzczksp

    // Paypal sandbox seller account
    /// email : sb-pylt99012791@personal.example.com
    /// password : 1?kg&ARk
    
    // variables
    var parking : Parking?
    var reservation: Reservation?
    var braintreeClient: BTAPIClient!
    
    var paymentString : String?
    
    // iboutlets
    @IBOutlet weak var parkingNameLabel: UILabel!
    @IBOutlet weak var checkInDatePicker: UIDatePicker!
    @IBOutlet weak var checkOutDatePicker: UIDatePicker!
    @IBOutlet weak var disabledSwitch: UISwitch!
    @IBOutlet weak var specialGuardSwitch: UISwitch!
    
    // protocols
    
    
    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        braintreeClient = BTAPIClient(authorization: "sandbox_bn3zhb5z_vg22v8n96nzczksp")
        
        parkingNameLabel.text = "Park - " + (parking?.adresse)!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "paymentSegue" {
            let destination = segue.destination as! PaymentView
            destination.paymentString = paymentString
        }
    }
    
    // methods
    
    
    // actions
    @IBAction func bookSpace(_ sender: Any) {
        
        if (checkInDatePicker.date.timeIntervalSince(checkOutDatePicker.date) >= 0){
            self.present(Alert.makeAlert(titre: "Warning", message: "Check in time should be lower or equal to check out time"),animated: true)
            return
        }
        
        let payPalDriver = BTPayPalDriver(apiClient: braintreeClient)
        payPalDriver.viewControllerPresentingDelegate = self
        payPalDriver.appSwitchDelegate = self // Optional
        
        // Specify the transaction amount here. "2.32" is used in this example.
        let request = BTPayPalRequest(amount: String(parking!.prix!))
        request.currencyCode = "USD" // Optional; see BTPayPalRequest.h for more options
        
        payPalDriver.requestOneTimePayment(request) { [self] (tokenizedPayPalAccount, error) in
            if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
                
                // Access additional information
                
                let email = tokenizedPayPalAccount.email
                
                /*let firstName = tokenizedPayPalAccount.firstName
                 let lastName = tokenizedPayPalAccount.lastName
                 let phone = tokenizedPayPalAccount.phone
                 See BTPostalAddress.h for details
                 let billingAddress = tokenizedPayPalAccount.billingAddress
                 let shippingAddress = tokenizedPayPalAccount.shippingAddress*/
                
                
                paymentString =
                "You have successfuly paid "
                + String(parking!.prix!)
                + " USD using the paypal account : "
                + email!
                
                let reservation = Reservation(dateEntre: checkInDatePicker.date, dateSortie: checkOutDatePicker.date,disabledPark: disabledSwitch.isOn,specialGuard: specialGuardSwitch.isOn, parking: parking, userFromPark: (parking?.user!)!)
                
                ReservationViewModel().addReservation(reservation: reservation) { success in
                    if success {
                        performSegue(withIdentifier: "paymentSegue", sender: paymentString)
                    } else {
                        self.present(Alert.makeAlert(titre: "Error", message: "Could not book a reservation"),animated:true)
                    }
                }
                
            } else if let error = error {
                print(error)
            } else {
                // Buyer canceled payment approval
            }
        }
    }
}

extension ReservationView : BTViewControllerPresentingDelegate{
    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
        
    }
    
    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        
    }
    
    
}

extension ReservationView : BTAppSwitchDelegate{
    func appSwitcherWillPerformAppSwitch(_ appSwitcher: Any) {
        
    }
    
    func appSwitcher(_ appSwitcher: Any, didPerformSwitchTo target: BTAppSwitchTarget) {
        
    }
    
    func appSwitcherWillProcessPaymentInfo(_ appSwitcher: Any) {
        
    }
    
    
}
