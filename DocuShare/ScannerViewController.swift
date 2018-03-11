//
//  ScannerViewController.swift
//  DocuShare
//
//  Created by Georgeena Thomas on 12/15/17.
//  Copyright © 2017 Pushkar Khedekar. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var userID : String?
    var user : User?
    var captureSession : AVCaptureSession?
    var videoPreviewLayer : AVCaptureVideoPreviewLayer?
    var qrCodeFrameView : UIView?
    var document : Document?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(userID!)
        initiallizeCaptureSession()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initiallizeCaptureSession() {
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
       
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            captureSession?.startRunning()
            
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView{
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
        } catch {
            print(error)
            return
        }
       
    }
    
    
    func captureOutput(_ output: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            createAlert("Try Again", "Not a valid QR Code")
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            let  barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                let asGroup = DispatchGroup()
                asGroup.enter()
                fetchDocument(metadataObj.stringValue!,asGroup)
                asGroup.notify(queue: .main, execute: {
                    if self.document == nil {
                        self.createAlert("Broken Link", "Document not found.")
                        return
                    } else {
                        
                        let docViewCtrl =  self.storyboard?.instantiateViewController(withIdentifier: "popUpDoc") as! DocumentDisplayPopUpController
                        docViewCtrl.document = self.document
                        self.present(docViewCtrl, animated: true, completion: nil)
                    }
                })
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func createAlert(_ title : String,_ message : String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true) {}
    }
    
    func fetchDocument(_ docID : String,_ asGroup : DispatchGroup) {
        print(docID)
        
        Database.database().reference(fromURL: "https://docushare-documents-on-the-go.firebaseio.com/").child("documentList").child(docID).observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                print(dictionary)
                self.document = Document()
                self.document!.setValuesForKeys(dictionary)
                asGroup.leave()
            }
        }, withCancel: nil)
    }
}
