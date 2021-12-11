//
//  ProfileView.swift
//  Carypark
//
//  Created by Mac-Mini_2021 on 28/11/2021.
//

import Foundation
import UIKit
import FBSDKLoginKit

protocol ModalDelegate {
    func initProfileFromEdit()
}

class ProfileView: UIViewController, ModalDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    // variables
    let token = UserDefaults.standard.string(forKey: "userToken")!
    var user : User?
    
    // iboutlets
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var CarNumberLabel: UILabel!
    @IBOutlet weak var carNumberTF: UITextField!
    @IBOutlet weak var imageUser: UIImageView!
    
    // protocols
    func initProfileFromEdit() {
        initializeProfile()
    }
    
    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTF.isEnabled = false
     
        initializeProfile()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        SecondModalTransitionMediator.instance.sendPopoverDismissed(modelChanged: true)
    }
    
    // methods
    func initializeProfile() {
        print("initializing profile")
        UserViewModel().getUserFromToken(userToken: token, completed: { [self] success, result in
            if success {
                user = result
                fullNameTF.text = user?.fullName
                emailTF.text = user?.email
                phoneTF.text = user?.phone
                
                if user?.role == "NormalUser" {
                    carNumberTF.text = user?.car
                    carNumberTF.isHidden = false
                    CarNumberLabel.isHidden = false
                }else{
                    carNumberTF.isHidden = true
                    CarNumberLabel.isHidden = true
                }
                
                if user?.photo != nil {
                    ImageLoader.shared.loadImage(identifier:(user?.photo)!, url: "http://localhost:3000/img/"+(user?.photo)!, completion: {image in
                        imageUser.image = image
                    })
                }
                
            } else {
                present(Alert.makeAlert(titre: "Error", message: "Could not verify token"), animated: true
                )
            }
        })
    }
    
    @IBAction func changePhoto(_ sender: Any) {
        showActionSheet()
    }
    
    func showActionSheet(){
        
        let actionSheetController: UIAlertController = UIAlertController(title: NSLocalizedString("Upload Image", comment: ""), message: nil, preferredStyle: .actionSheet)
        actionSheetController.view.tintColor = UIColor.black
        let cancelActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        let saveActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Take Photo", comment: ""), style: .default)
        { action -> Void in
            //self.camera()
        }
        actionSheetController.addAction(saveActionButton)
        
        let deleteActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Choose From Gallery", comment: ""), style: .default)
        { action -> Void in
            self.gallery()
        }
        
        actionSheetController.addAction(deleteActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            
            return
        }
        
        UserViewModel().uploadImageProfile(uiImage: selectedImage,completed: { success in
            if success {
                self.initializeProfile()
            }
        })
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func gallery()
    {
        let myPickerControllerGallery = UIImagePickerController()
        myPickerControllerGallery.delegate = self
        myPickerControllerGallery.sourceType = UIImagePickerController.SourceType.photoLibrary
        myPickerControllerGallery.allowsEditing = true
        self.present(myPickerControllerGallery, animated: true, completion: nil)
    }
    
    // actions
    @IBAction func confirmChanges(_ sender: Any) {
        
        if fullNameTF.text!.isEmpty || phoneTF.text!.isEmpty || carNumberTF.text!.isEmpty {
            self.present(Alert.makeAlert(titre: "Warning", message: "Please fill all the fields"), animated: true)
            return
        }
        
        if Int(phoneTF.text!) == nil {
            self.present(Alert.makeAlert(titre: "Warning", message: "Phone should be a number"),animated: true)
            return
        }
        
        if phoneTF.text?.count != 8 {
            self.present(Alert.makeAlert(titre: "Warning", message: "Phone should have 8 digits"),animated: true)
            return
        }
        
        if !(user?.role == "ParkOwner"){
            if (carNumberTF.text?.contains("TUN") == false){
                self.present(Alert.makeAlert(titre: "Warning", message: "Please type your car number correctly"), animated: true)
            }
        }
        
        //user?.email = emailTF.text
        user?.fullName = fullNameTF.text
        user?.phone = phoneTF.text
        
        if !(user?.role == "²"){
            user?.car = carNumberTF.text
        } else {
            user?.car = ""
        }
        
        UserViewModel().editProfile(user: user!) { success in
            if success {
                let action = UIAlertAction(title: "Proceed", style: .default) { UIAlertAction in
                    self.dismiss(animated: true, completion: nil)
                }
                self.present(Alert.makeSingleActionAlert(titre: "Success", message: "Profile edited successfully", action: action), animated: true)
            } else {
                self.present(Alert.makeAlert(titre: "Error", message: "Could not edit your profile"), animated: true)
            }
        }
    }
}
