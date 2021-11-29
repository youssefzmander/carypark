//
//  User.swift
//  Carypark
//
//  Created by Mac-Mini_2021 on 10/11/2021.
//

import Foundation

struct User: Encodable {
    
    var _id : String?
    var fullName : String?
    var email : String?
    var password : String?
    var role : String?
    var isVerified : Bool?
    
    init(_id: String? = nil, fullName: String? = nil, email: String? = nil, password: String? = nil, role: String? = nil, isVerified: Bool? = nil) {
        self._id = _id
        self.fullName = fullName
        self.email = email
        self.password = password
        self.role = role
        self.isVerified = isVerified
    }
    
}
