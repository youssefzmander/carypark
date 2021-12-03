//
//  Parking.swift
//  Carypark
//
//  Created by Mac-Mini_2021 on 10/11/2021.
//

import Foundation

struct Parking: Encodable {
    
    internal init(_id: String? = nil, adresse: String? = nil, nbrPlace: Int? = nil, longitude: Double? = nil, latitude: Double? = nil, prix: Float? = nil, idUser: String? = nil) {
        self._id = _id
        self.adresse = adresse
        self.nbrPlace = nbrPlace
        self.longitude = longitude
        self.latitude = latitude
        self.prix = prix
        self.idUser = idUser
    }
    

    var _id: String?
    var adresse: String?
    var nbrPlace: Int?
    var longitude: Double?
    var latitude: Double?
    var prix: Float?
    var idUser: String?
    
}
