//
//  IncomingRidesView.swift
//  carypark
//
//  Created by Mac-Mini_2021 on 2/12/2021.
//

import UIKit


class GuardianIncomingRides: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
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
        let timeRemainingLabel = contentView?.viewWithTag(4) as! UILabel
        
        
        
        buttonForPrice.setTitle(String((reservations[indexPath.row].parking?.prix!)!) + "DT/Hr", for: .normal)
        parkingNameLabel.text = reservations[indexPath.row].parking?.adresse
        parkingLocationLabel.text = String((reservations[indexPath.row].parking?.longitude!)!) + ", " + String((reservations[indexPath.row].parking?.latitude!)!)
        timeRemainingLabel.text = reservations[indexPath.row].parking?._id
        
        return mCell!
    }
    
    
    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeHistory()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initializeHistory()
    }
    
    // methods
    func initializeHistory() {
        ReservationViewModel().getMyReservatio { success, reservationsFromRep in
            if success {
                self.reservations = reservationsFromRep!
                self.tableView.reloadData()
            } else {
                self.present(Alert.makeAlert(titre: "Error", message: "Could not load history"),animated: true)
            }
        }
    }
    
    // actions
    
}
