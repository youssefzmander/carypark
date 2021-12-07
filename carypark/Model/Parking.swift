//
//  Parking.swift
//  Carypark
//
//  Created by Mac-Mini_2021 on 10/11/2021.
//

import Foundation

struct Parking: Encodable {
    
    internal init(_id: String? = nil, adresse: String? = nil, nbrPlace: Int? = nil, longitude: Double? = nil, latitude: Double? = nil, prix: Float? = nil, user: User? = nil, reservations: [Reservation]? = nil) {
        self._id = _id
        self.adresse = adresse
        self.nbrPlace = nbrPlace
        self.longitude = longitude
        self.latitude = latitude
        self.prix = prix
        self.user = user
        self.reservations = reservations
    }
    
    var _id: String?
    var adresse: String?
    var nbrPlace: Int?
    var longitude: Double?
    var latitude: Double?
    var prix: Float?
    
    var user : User?
    var reservations: [Reservation]?
    
}
