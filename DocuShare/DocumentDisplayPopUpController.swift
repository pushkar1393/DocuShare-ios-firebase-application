//
//  DocumentDisplayPopUpController.swift
//  DocuShare
//
//  Created by Georgeena Thomas on 12/15/17.
//  Copyright © 2017 Pushkar Khedekar. All rights reserved.
//

import UIKit

class DocumentDisplayPopUpController: UIViewController {
    

    var image : UIImage?
    var document : Document?
    
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    @IBOutlet weak var documentView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner!.hidesWhenStopped = true
        spinner!.startAnimating()
        setUpImage()
        // Do any additional setup after loading the view.
    }

    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpImage() {
        let session = URLSession(configuration: .default)
        if let docURL = document?.documentURL {
            let url = URL(string: docURL)
            //print(url)
            let downloadPic = session.dataTask(with: url!, completionHandler: {
                (data,response,error) in
                
                if error != nil {
                   // print(error)
                    return
                }
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        self.documentView.image = image
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
