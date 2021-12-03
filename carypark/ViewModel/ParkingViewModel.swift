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
                    for singleJsonItem in JSON(response.data!)["parking"] {
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
                    "idUser": parking.idUser!
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
                    "longitude": parking.longitude!,
                    "latitude": parking.latitude!,
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
    
    func makeParking(jsonItem: JSON) -> Parking {
        return Parking(
            _id: jsonItem["_id"].stringValue,
            adresse: jsonItem["adresse"].stringValue,
            nbrPlace: jsonItem["nbrPlace"].intValue,
            longitude: jsonItem["longitude"].doubleValue,
            latitude: jsonItem["latitude"].doubleValue,
            prix: jsonItem["prix"].floatValue,
            idUser: jsonItem["idUser"].stringValue
        )
    }
}
