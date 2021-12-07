//
//  GuardianProfileView.swift
//  carypark
//
//  Created by Mac-Mini_2021 on 3/12/2021.
//

import Foundation
import UIKit
import FBSDKLoginKit

class GuardianProfileView: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    // variables
    
    // iboutlets
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var imageUser: UIImageView!
    
    // protocols
    
    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeProfile()
    
    }
    
    
    // methods
    func initializeProfile(){
        UserViewModel().getUserFromToken(userToken: UserDefaults.standard.string(forKey: "userToken")!) { [self] success, user in
            profileName.text = user?.fullName
            
            let url = "http://localhost:3000/img/"+(user?.photo)!
            print(url)
            if user?.photo != nil {
                ImageLoader.shared.loadImage(identifier:(user?.photo)!, url: url, completion: {image in
                    print(url)
                    imageUser.image = image
                                
                })
            }
        }
    }
    
    // actions
    @IBAction func logout(_ sender: Any) {
        print("logging out")
        
        let loginManager = LoginManager()
        loginManager.logOut()
        
        UserDefaults.standard.set(nil, forKey: "userToken")
        self.performSegue(withIdentifier: "logoutSegue", sender:nil)
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
    
    @IBAction func parkingHistory(_ sender: Any) {
        self.tabBarController?.selectedIndex = 4
    }
    
    @IBAction func incomingRides(_ sender: Any) {
        self.tabBarController?.selectedIndex = 3
    }
}
