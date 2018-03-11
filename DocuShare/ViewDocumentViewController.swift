//
//  ViewDocumentViewController.swift
//  DocuShare
//
//  Created by Georgeena Thomas on 12/16/17.
//  Copyright © 2017 Pushkar Khedekar. All rights reserved.
//

import UIKit

class ViewDocumentViewController: UIViewController {

    var document : Document?
    
    @IBOutlet weak var docNamelbl: UILabel!
    
    @IBOutlet weak var docsaveLock: UILabel!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var docView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.hidesWhenStopped = true
        spinner!.startAnimating()
        fetchDoc()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchDoc() {
        docNamelbl.text = document?.documentName
        docsaveLock.text = document?.saveLock  == "true" ? "Save Protection is ON" : "Save Protection is OFF"
        
        let session = URLSession(configuration: .default)
        if let docURL = document?.documentURL?.substring(from: (document?.documentURL?.index(of: "http"))!) {
            let url = URL(string: docURL)
            let downloadPic = session.dataTask(with: url!, completionHandler: {
                (data,response,error) in
                
                if error != nil {
                    // print(error)
                    return
                }
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        self.docView.image = image
                        self.spinner!.stopAnimating()
                    }
                }
            })
            downloadPic.resume()
            
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

}
