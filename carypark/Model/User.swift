//
//  User.swift
//  Carypark
//
//  Created by Mac-Mini_2021 on 10/11/2021.
//

import Foundation

struct User: Encodable {
    
    internal init(_id: String? = nil, fullName: String? = nil, email: String? = nil, password: String? = nil, cin: String? = nil, car: String? = nil, address: String? = nil, phone: String? = nil, role: String? = nil, photo: String? = nil, isVerified: Bool? = nil, reservation: [Reservation]? = nil, parking: [Parking]? = nil) {
        self._id = _id
        self.fullName = fullName
        self.email = email
        self.password = password
        self.cin = cin
        self.car = car
        self.address = address
        self.phone = phone
        self.role = role
        self.photo = photo
        self.isVerified = isVerified
        self.reservation = reservation
        self.parking = parking
    }
    
    var _id: String?
    var fullName: String?
    var email: String?
    var password: String?
    var cin: String?
    var car: String?
    var address: String?
    var phone: String?
    var role: String?
    var photo: String?
    var isVerified: Bool?
    
    var reservation: [Reservation]?
    var parking: [Parking]?
    
}
