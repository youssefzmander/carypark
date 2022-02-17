//
//  Reservation.swift
//  Carypark
//
//  Created by Mac-Mini_2021 on 10/11/2021.
//

import Foundation

struct Reservation: Encodable {
    
    var _id: String?
    var dateEntre: Date?
    var dateSortie: Date?
    var disabledPark: Bool
    var specialGuard: Bool
    
    var parking: Parking?
    var user: User?
    var userFromPark: User
}
