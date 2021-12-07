//
//  ReservationViewModel.swift
//  Carypark
//
//  Created by Mac-Mini_2021 on 10/11/2021.
//

import SwiftyJSON
import Alamofire
import UIKit.UIImage

class ReservationViewModel {

    func getMyReservationsAsOwner(completed: @escaping (Bool, [Reservation]?) -> Void ) {
        AF.request(Constants.serverUrl + "/reservation/owner-my",
                   method: .post,
                   parameters: [
                    "user": UserDefaults.standard.string(forKey: "userId")
                   ])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    var reservations : [Reservation]? = []
                    for singleJsonItem in JSON(response.data!)["reservations"] {
                        reservations!.append(self.makeReservation(jsonItem: singleJsonItem.1))
                    }
                    completed(true, reservations)
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    
    func getMyReservationsAsNormal(completed: @escaping (Bool, [Reservation]?) -> Void ) {
        AF.request(Constants.serverUrl + "/reservation/normal-my",
                   method: .post,
                   parameters: [
                    "user": UserDefaults.standard.string(forKey: "userId")
                   ])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    var reservations : [Reservation]? = []
                    for singleJsonItem in JSON(response.data!)["reservations"] {
                        reservations!.append(self.makeReservation(jsonItem: singleJsonItem.1))
                    }
                    completed(true, reservations)
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    
    func getReservation(_id: String?, completed: @escaping (Bool, Reservation?) -> Void ) {
        AF.request(Constants.serverUrl + "/reservation/",
                   method: .get,
                   parameters: [
                    "_id": _id!
                   ])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.data!)
                    let reservation = self.makeReservation(jsonItem: jsonData["reservation"])
                    completed(true, reservation)
                case let .failure(error):
                    print(error)
                    completed(false, nil)
                }
            }
    }
    
    func addReservation(reservation: Reservation, completed: @escaping (Bool) -> Void ) {
        AF.request(Constants.serverUrl + "/reservation/",
                   method: .post,
                   parameters: [
                    "dateEntre": reservation.dateEntre!,
                    "dateSortie": reservation.dateSortie!,
                    "parking": reservation.parking!._id!,
                    "user": UserDefaults.standard.string(forKey: "userId")!
                   ])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    completed(true)
                case let .failure(error):
                    print(error)
                    completed(false)
                }
            }
    }
    
    func editReservation(reservation: Reservation, completed: @escaping (Bool) -> Void ) {
        AF.request(Constants.serverUrl + "/reservation/",
                   method: .put,
                   parameters: [
                    "_id": reservation._id!,
                    "dateEntre": reservation.dateEntre!,
                    "dateSortie": reservation.dateSortie!,
                    "parking": reservation.parking!._id!
                   ])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    completed(true)
                case let .failure(error):
                    print(error)
                    completed(false)
                }
            }
    }
    
    func deleteReservation(_id: String?, completed: @escaping (Bool) -> Void ) {
        AF.request(Constants.serverUrl + "/reservation/",
                   method: .delete,
                   parameters: [
                    "_id": _id!
                   ])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    completed(true)
                case let .failure(error):
                    print(error)
                    completed(false)
                }
            }
    }
    
    func makeReservation(jsonItem: JSON) -> Reservation {
        Reservation(
            _id: jsonItem["_id"].stringValue,
            dateEntre: Date(), //jsonItem["dateEntre"].stringValue,
            dateSortie: Date(), //jsonItem["dateSortie"].stringValue,
            parking: makeParking(jsonItem: jsonItem["parking"]),
            user: makeUser(jsonItem: jsonItem["user"])
        )
    }
    
    func makeParking(jsonItem: JSON) -> Parking {
        return Parking(
            _id: jsonItem["_id"].stringValue,
            adresse: jsonItem["adresse"].stringValue,
            nbrPlace: jsonItem["nbrPlace"].intValue,
            longitude: jsonItem["longitude"].doubleValue,
            latitude: jsonItem["latitude"].doubleValue,
            prix: jsonItem["prix"].floatValue
        )
    }
    
    func makeUser(jsonItem: JSON) -> User {
        User(
            _id: jsonItem["_id"].stringValue,
            fullName: jsonItem["fullName"].stringValue,
            email: jsonItem["email"].stringValue,
            cin: jsonItem["cin"].stringValue,
            car: jsonItem["car"].stringValue,
            address: jsonItem["address"].stringValue,
            phone: jsonItem["phone"].stringValue,
            role: jsonItem["role"].stringValue,
            isVerified: jsonItem["isVerified"].boolValue
        )
    }
}
