//
//  ReservationView.swift
//  carypark
//
//  Created by Mac-Mini_2021 on 2/12/2021.
//

import UIKit


class HistoryView: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    // variables
    var reservations : [Reservation] = []
    
    // iboutlets
    @IBOutlet weak var tableView: UITableView!
    
    // protocols
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mCell = tableView.dequeueReusableCell(withIdentifier: "mCell")
        let contentView = mCell?.contentView
        
        let buttonForPrice = contentView?.viewWithTag(1) as! UIButton
        let parkingNameLabel = contentView?.viewWithTag(2) as! UILabel
        let parkingLocationLabel = contentView?.viewWithTag(3) as! UILabel
        
        let personImageView = contentView?.viewWithTag(4) as! UIImageView
        let personNameLabel = contentView?.viewWithTag(5) as! UILabel
        let personEmailLabel = contentView?.viewWithTag(6) as! UILabel
        let personPhoneLabel = contentView?.viewWithTag(7) as! UILabel
        
        let dateLabel = contentView?.viewWithTag(8) as! UILabel
        
        let checkInTimeLabel = contentView?.viewWithTag(9) as! UILabel
        let checkOutTimeLabel = contentView?.viewWithTag(10) as! UILabel
        
        let disabledParkLabel = contentView?.viewWithTag(11) as! UILabel
        let specialGuardLabel = contentView?.viewWithTag(12) as! UILabel
        
        let timeRemainingLabel = contentView?.viewWithTag(13) as! UILabel
        
        let reservation = reservations[indexPath.row]
        
        buttonForPrice.setTitle(String((reservation.parking?.prix!)!) + "DT/Hr", for: .normal)
        parkingNameLabel.text = reservation.parking?.adresse
        parkingLocationLabel.text = String((reservation.parking?.longitude!)!) + ", " + String((reservation.parking?.latitude!)!)
        
        let user = reservation.userFromPark
        
        if user.photo != nil {
            ImageLoader.shared.loadImage(identifier:(user.photo)!, url: "http://localhost:3000/img/"+(user.photo)!, completion: {image in
                personImageView.image = image
                            
            })
        }
        
        personNameLabel.text = user.fullName
        personEmailLabel.text = user.email
        personPhoneLabel.text = user.phone
        
        dateLabel.text = DateUtils.formatFromDateForDisplayYearMonthDay(date: reservations[indexPath.row].dateEntre!)
        
        checkInTimeLabel.text = DateUtils.formatFromDateForDisplayHoursMin(date: reservations[indexPath.row].dateEntre!)
        checkOutTimeLabel.text = DateUtils.formatFromDateForDisplayHoursMin(date: reservations[indexPath.row].dateSortie!)
        
        if reservation.disabledPark {
            disabledParkLabel.text = "Yes"
        } else {
            disabledParkLabel.text = "No"
        }
        
        if reservation.specialGuard {
            specialGuardLabel.text = "Yes"
        } else {
            specialGuardLabel.text = "No"
        }
        
        let timeRemainingInSeconds = reservation.dateEntre?.timeIntervalSince(reservation.dateSortie!)
        let timeRemaining = DateUtils().secondsToHoursMinutesSeconds(Int(abs(timeRemainingInSeconds!)))
        timeRemainingLabel.text = String(timeRemaining.0) + " Hours and " + String(timeRemaining.1) + " Minutes"
        
        return mCell!
    }
    
    
    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initializeHistory()
    }
    
    // methods
    func initializeHistory() {
        ReservationViewModel().getMyReservationsAsNormal(completed: { success, reservationsFromRep in
            if success {
                self.reservations = reservationsFromRep!
                self.tableView.reloadData()
            } else {
                self.present(Alert.makeAlert(titre: "Error", message: "Could not load history"),animated: true)
            }
        })
    }
    
    // actions
    
}
