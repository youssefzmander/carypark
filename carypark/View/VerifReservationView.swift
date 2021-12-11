//
//  QrCodeView.swift
//  carypark
//
//  Created by Apple Mac on 11/12/2021.
//

import Foundation
import UIKit

class VerifReservationView: UIViewController {
    
    var idReservation : String?
    
    // iboutlets
    @IBOutlet weak var parkingPriceLabel: UIButton!
    @IBOutlet weak var parkingNameLabel: UILabel!
    @IBOutlet weak var parkingLocationLabel: UILabel!
    @IBOutlet weak var incomingPersonLabel: UILabel!
    @IBOutlet weak var incomingPersonEmailLabel: UILabel!
    @IBOutlet weak var incomingPersonePhoneLabel: UILabel!
    @IBOutlet weak var incomingPersonCarLabel: UILabel!
    @IBOutlet weak var reservationDateLabel: UILabel!
    @IBOutlet weak var checkInTimeLabel: UILabel!
    @IBOutlet weak var checkOutTimeLabel: UILabel!
    @IBOutlet weak var parkIsDisabledLabel: UILabel!
    @IBOutlet weak var parkIsSpecialGuardLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    // lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (UserDefaults.standard.string(forKey: "userId") == nil) {
            self.present(Alert.makeSingleActionAlert(titre: "Warning", message: "Please log in", action: UIAlertAction(title: "Ok", style: .default, handler: { UIAlertAction in
                    self.dismiss(animated: true, completion: nil)
            })),animated: true)
        } else {
            initializeView()
        }
        
    }
    
    // methods
    func initializeView() {
        ReservationViewModel().getReservationById(_id: idReservation) { [self] success, reservation in
            if success {
                parkingPriceLabel.setTitle(String(reservation!.parking!.prix!), for: .normal)
                parkingNameLabel.text = reservation?.parking?.adresse
                parkingLocationLabel.text =  String(reservation!.parking!.latitude!) + ", " + String(reservation!.parking!.longitude!)
                incomingPersonLabel.text = reservation?.user?.fullName
                incomingPersonEmailLabel.text = reservation?.user?.email
                incomingPersonePhoneLabel.text = reservation?.user?.phone
                incomingPersonCarLabel.text = reservation?.user?.car
                reservationDateLabel.text = DateUtils.formatFromDateForDisplayYearMonthDay(date: (reservation?.dateEntre)!)
                checkInTimeLabel.text = DateUtils.formatFromDateForDisplayHoursMin(date: (reservation?.dateEntre)!)
                checkOutTimeLabel.text = DateUtils.formatFromDateForDisplayHoursMin(date: (reservation?.dateSortie)!)
                
                if reservation!.disabledPark {
                    parkIsDisabledLabel.text = "Yes"
                } else {
                    parkIsDisabledLabel.text = "No"
                }
                
                if reservation!.specialGuard {
                    parkIsSpecialGuardLabel.text = "Yes"
                } else {
                    parkIsSpecialGuardLabel.text = "No"
                }
                
                let timeRemainingInSeconds = reservation?.dateEntre?.timeIntervalSince((reservation?.dateSortie!)!)
                let timeRemaining = DateUtils().secondsToHoursMinutesSeconds(Int(abs(timeRemainingInSeconds!)))
                timeLabel.text = String(timeRemaining.0) + " Hours and " + String(timeRemaining.1) + " Minutes"
            } else {
                self.present(Alert.makeSingleActionAlert(titre: "Warning", message: "This reservation is not yours", action: UIAlertAction(title: "Ok", style: .default, handler: { UIAlertAction in
                        self.dismiss(animated: true, completion: nil)
                })),animated: true)
            }
        }
    }
}
