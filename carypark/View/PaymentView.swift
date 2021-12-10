//
//  PaymentView.swift
//  Carypark
//
//  Created by Mac-Mini_2021 on 25/11/2021.
//

import UIKit
import Braintree

class PaymentView: UIViewController {

    // variables
    var paymentString: String?
    
    // iboutlets
    @IBOutlet weak var paymentText: UILabel!
    
    // protocols
    
    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paymentText.text = paymentString
    }
    
    // methods
    
    // actions
    
}

