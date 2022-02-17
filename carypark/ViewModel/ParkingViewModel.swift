//
//  ParkingViewModel.swift
//  Carypark
//
//  Created by Mac-Mini_2021 on 10/11/2021.
//

import SwiftyJSON
import Alamofire
import UIKit.UIImage

class ParkingViewModel {

    func getAllParking(completed: @escaping (Bool, [Parking]?) -> Void ) {
        AF.request(Constants.serverUrl + "/parking/",
                   method: .get)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    var parkings : [Parking]? = []
                    for singleJsonItem in JSON(response.data!)["parkings"] {
                        parkings!.append(self.makeParking(jsonItem: singleJsonItem.1))
                    }
                    completed(true, parkings)
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    
    func getMyParkings(completed: @escaping (Bool, [Parking]?) -> Void ) {
        AF.request(Constants.serverUrl + "/parking/my",
                   method: .post,
                   parameters: [
                    "user": UserDefaults.standard.string(forKey: "userId")
                   ])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    var parkings : [Parking]? = []
                    for singleJsonItem in JSON(response.data!)["parkings"] {
                        parkings!.append(self.makeParking(jsonItem: singleJsonItem.1))
                    }
                    completed(true, parkings)
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    
    func getParkingById(_id: String?, completed: @escaping (Bool, Parking?) -> Void ) {
        AF.request(Constants.serverUrl + "/parking/with-id",
                   method: .post,
                   parameters: [ "_id": _id])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.data!)
                    let parking = self.makeParking(jsonItem: jsonData["parking"])
                    print(parking)
                    completed(true, parking)
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    
    func addParking(parking: Parking, completed: @escaping (Bool) -> Void ) {
        AF.request(Constants.serverUrl + "/parking/",
                   method: .post,
                   parameters: [
                    "adresse": parking.adresse!,
                    "nbrPlace": parking.nbrPlace!,
                    "longitude": parking.longitude!,
                    "latitude": parking.latitude!,
                    "prix": parking.prix!,
                    "user": UserDefaults.standard.string(forKey: "userId")!
                   ])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    completed(true)
                case let .failure(error):
                    debugPrint(error)
                    completed(false)
                }
            }
    }
    
    func editParking(parking: Parking, completed: @escaping (Bool) -> Void ) {
        AF.request(Constants.serverUrl + "/parking/",
                   method: .put,
                   parameters: [
                    "_id": parking._id!,
                    "adresse": parking.adresse!,
                    "nbrPlace": parking.nbrPlace!,
                    "prix": parking.prix!
                   ])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    completed(true)
                case let .failure(error):
                    debugPrint(error)
                    completed(false)
                }
            }
    }
    
    func deleteParking(_id: String?, completed: @escaping (Bool) -> Void ) {
        AF.request(Constants.serverUrl + "/parking/",
                   method: .delete,
                   parameters: [
                    "_id": _id!
                   ],
                   encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    completed(true)
                case let .failure(error):
                    debugPrint(error)
                    completed(false)
                }
            }
    }
    
    func makeParking(jsonItem: JSON) -> Parking {
        var reservations : [Reservation] = []
        for singleJsonItem in jsonItem["reservations"] {
            reservations.append(makeReservation(jsonItem: singleJsonItem.1))
        }
        print("---------------")
        print(jsonItem["user"] )
        print("---------------")
        return Parking(
            _id: jsonItem["_id"].stringValue,
            adresse: jsonItem["adresse"].stringValue,
            nbrPlace: jsonItem["nbrPlace"].intValue,
            longitude: jsonItem["longitude"].doubleValue,
            latitude: jsonItem["latitude"].doubleValue,
            prix: jsonItem["prix"].floatValue,
            user: makeUser(jsonItem: jsonItem["user"]),
            reservations: reservations
        )
    }
    
    func makeReservation(jsonItem: JSON) -> Reservation {
        Reservation(
            _id: jsonItem["_id"].stringValue,
            dateEntre: DateUtils.formatFromString(string: jsonItem["dateEntre"].stringValue),
            dateSortie: DateUtils.formatFromString(string: jsonItem["dateSortie"].stringValue),
            disabledPark: jsonItem["disabledPark"].boolValue,
            specialGuard: jsonItem["specialGuard"].boolValue,
            user: makeUser(jsonItem: jsonItem["user"]),
            userFromPark: makeUser(jsonItem: jsonItem["userFromPark"])
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
            photo: jsonItem["photo"].stringValue,
            isVerified: jsonItem["isVerified"].boolValue
        )
    }
}
