//
//  UserViewModel.swift
//  Carypark
//
//  Created by Mac-Mini_2021 on 10/11/2021.
//

import SwiftyJSON
import Alamofire
import UIKit.UIImage

class UserViewModel {
    
    func uploadImageProfile( uiImage: UIImage, completed: @escaping (Bool) -> Void) {
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(uiImage.jpegData(compressionQuality: 0.5)!, withName: "image" , fileName: "image.jpeg", mimeType: "image/jpeg")
            
            for (key, value) in ["user" : UserDefaults.standard.string(forKey: "userId")] {
                multipartFormData.append((value!.data(using: .utf8))!, withName: key)
            }
            
        },to: Constants.serverUrl + "/user/editProfilePic",
                  method: .post)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    print("Success")
                    completed(true)
                case let .failure(error):
                    completed(false)
                    print(error)
                }
            }
    }
    
    func signUp(user: User, completed: @escaping (Bool) -> Void ) {
        print(user)
        
        AF.request(Constants.serverUrl + "/user/signUp",
                   method: .post,
                   parameters: [
                    "fullName": user.fullName!,
                    "phone": user.phone!,
                    "email": user.email!,
                    "password": user.password!,
                    "role": user.role!,
                    "car": user.car!
                   ])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    print("Success")
                    completed(true)
                case let .failure(error):
                    print(error)
                    completed(false)
                }
            }
    }
    
    func login(email: String, password: String, completed: @escaping (Bool, Any?) -> Void ) {
        AF.request(Constants.serverUrl + "/user/login",
                   method: .post,
                   parameters: [
                    "email": email,
                    "password": password
                   ],
                   encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .response { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.data!)
                    let user = self.makeUser(jsonItem: jsonData["user"])
                    UserDefaults.standard.setValue(jsonData["token"].stringValue, forKey: "userToken")
                    UserDefaults.standard.setValue(user._id, forKey: "userId")
                    completed(true, user)
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    
    func getUserFromToken(userToken: String, completed: @escaping (Bool, User?) -> Void ) {
        AF.request(Constants.serverUrl + "/user/getUserFromToken",
                   method: .post,
                   parameters: ["userToken": userToken],
                   encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .response { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.data!)
                    let user = self.makeUser(jsonItem: jsonData["user"])
                    print(user)
                    completed(true, user)
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    
    func loginWithSocialApp(email: String, name: String, role : String, completed: @escaping (Bool, User?) -> Void ) {
        AF.request(Constants.serverUrl + "/user/loginWithSocialApp",
                   method: .post,
                   parameters: ["email": email, "name": name, "role": role ],
                   encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .response { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.data!)
                    let user = self.makeUser(jsonItem: jsonData["user"])
                    
                    print("this is the new token value : " + jsonData["token"].stringValue)
                    UserDefaults.standard.setValue(jsonData["token"].stringValue, forKey: "userToken")
                    UserDefaults.standard.setValue(user._id, forKey: "userId")
                    
                    completed(true, user)
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    
    func resendConfirmation(email: String, completed: @escaping (Bool) -> Void ) {
        AF.request(Constants.serverUrl + "/user/resendConfirmation",
                   method: .post,
                   parameters: ["email": email])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    print("Success")
                    completed(true)
                case let .failure(error):
                    print(error)
                    completed(false)
                }
            }
    }
    
    func forgotPassword(email: String, resetCode: String, completed: @escaping (Bool) -> Void ) {
        AF.request(Constants.serverUrl + "/user/forgotPassword",
                   method: .post,
                   parameters: ["email": email, "resetCode": resetCode])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    print("Success")
                    completed(true)
                case let .failure(error):
                    print(error)
                    completed(false)
                }
            }
    }
    
    func editPassword(email: String?, newPassword: String?, completed: @escaping (Bool) -> Void ) {
        AF.request(Constants.serverUrl + "/user/editPassword",
                   method: .put,
                   parameters: [
                    "email": email!,
                    "newPassword": newPassword!
                   ])
            .response { response in
                switch response.result {
                case .success:
                    print("Success")
                    completed(true)
                case let .failure(error):
                    print(error)
                    completed(false)
                }
            }
    }
    
    func editProfile(user: User, completed: @escaping (Bool) -> Void ) {
        
        AF.request(Constants.serverUrl + "/user/editProfile",
                   method: .put,
                   parameters: [
                    "_id" : user._id!,
                    "fullName": user.fullName!,
                    "phone": user.phone!,
                    "email": user.email!,
                    "password": user.password!,
                    "role": user.role!,
                    "car": user.car!
                   ])
            .response { response in
                switch response.result {
                case .success:
                    print("Success")
                    completed(true)
                case let .failure(error):
                    print(error)
                    completed(false)
                }
            }
    }
    
    func makeUser(jsonItem: JSON) -> User {
        User(
            _id: jsonItem["_id"].stringValue,
            fullName: jsonItem["fullName"].stringValue,
            email: jsonItem["email"].stringValue,
            password: jsonItem["password"].stringValue,
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
