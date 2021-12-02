//
//  PlaceViewModel.swift
//  Carypark
//
//  Created by Mac-Mini_2021 on 10/11/2021.
//

import SwiftyJSON
import Alamofire
import UIKit.UIImage

class PlaceViewModel {

    func getPlace(_id: String?, completed: @escaping (Bool, Place?) -> Void ) {
        AF.request(Constants.serverUrl + "/place/",
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
                    let place = self.makePlace(jsonItem: jsonData["place"])
                    completed(true, place)
                case let .failure(error):
                    completed(false, nil)
                }
            }
    }
    
    func addPlace(place: Place, completed: @escaping (Bool) -> Void ) {
        AF.request(Constants.serverUrl + "/place/",
                   method: .post,
                   parameters: [
                    "bloc": place.bloc!,
                    "disponibilite": place.disponibilite!,
                    "idParking": place.idParking!,
                    "idUser": place.idUser!
                   ])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    completed(true)
                case let .failure(error):
                    completed(false)
                }
            }
    }
    
    func editPlace(place: Place, completed: @escaping (Bool) -> Void ) {
        AF.request(Constants.serverUrl + "/place/",
                   method: .put,
                   parameters: [
                    "_id": place._id!,
                    "bloc": place.bloc!,
                    "disponibilite": place.disponibilite!,
                    "idParking": place.idParking!,
                    "idUser": place.idUser!
                   ])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    completed(true)
                case let .failure(error):
                    completed(false)
                }
            }
    }
    
    func deletePlace(_id: String?, completed: @escaping (Bool) -> Void ) {
        AF.request(Constants.serverUrl + "/place/",
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
                    completed(false)
                }
            }
    }
    
    func makePlace(jsonItem: JSON) -> Place {
        Place(
            _id: jsonItem["_id"].stringValue,
            bloc: jsonItem["bloc"].stringValue,
            disponibilite: jsonItem["disponibilite"].boolValue,
            idParking: jsonItem["idParking"].stringValue,
            idUser: jsonItem["idUser"].stringValue
        )
    }
}
