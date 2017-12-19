//
//  QRImageViewController.swift
//  DocuShare
//
//  Created by Georgeena Thomas on 12/15/17.
//  Copyright © 2017 Pushkar Khedekar. All rights reserved.
//

import UIKit

class QRImageViewController: UIViewController {

    var document : Document?
    var qrCodeImage : CIImage!
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var QRImageView: UIImageView!
    @IBOutlet weak var trial: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        trial.text = document?.documentName
        generateQRfromURL()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resizeQR(_ sender: Any) {
        QRImageView.transform = CGAffineTransform(scaleX: CGFloat(slider.value), y: CGFloat(slider.value))
    }
    func generateQRfromURL() {
        if qrCodeImage == nil {
            
            let data = document!.documentURL?.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
    
         let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
            
            qrCodeImage = filter?.outputImage
            //QRImageView.image = UIImage(ciImage: qrCodeImage)
            blurFixQRCode()
        }
    }

    func blurFixQRCode() {
        let x = QRImageView.frame.size.width/qrCodeImage.extent.size.width
        let y = QRImageView.frame.size.height/qrCodeImage.extent.size.height
        
        let crispImage = qrCodeImage.applying(CGAffineTransform(scaleX: x, y: y))
        
        QRImageView.image = UIImage(ciImage: crispImage)
    }
  

}
