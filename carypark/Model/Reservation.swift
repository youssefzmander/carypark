//
//  Reservation.swift
//  Carypark
//
//  Created by Mac-Mini_2021 on 10/11/2021.
//

import Foundation

struct Reservation: Encodable {
    
    internal init(_id: String? = nil, dateEntre: Date? = nil, dateSortie: Date? = nil, parking: Parking? = nil, user: User? = nil) {
        self._id = _id
        self.dateEntre = dateEntre
        self.dateSortie = dateSortie
        self.parking = parking
        self.user = user
    }
    
    var _id: String?
    var dateEntre: Date?
    var dateSortie: Date?
    
    var parking: Parking?
    var user: User?
}
