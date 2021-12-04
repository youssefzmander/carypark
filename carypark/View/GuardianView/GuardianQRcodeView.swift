//
//  GuardianQRcode.swift
//  carypark
//
//  Created by Maher & Jamel on 4/12/2021.
//

import Foundation
import UIKit

class GuardianQRcodeView: UIViewController {
    
    // iboutlets
    @IBOutlet weak var qrCodeImage: UIImageView!
    
    // lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeView()
    }
    
    // methods
    func initializeView() {
        qrCodeImage.image = generateQRCode(from: "www.google.com")
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    
    // actions
}
