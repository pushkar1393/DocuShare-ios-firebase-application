//
//  MyDocsTableViewController.swift
//  DocuShare
//
//  Created by Pushkar Khedekar on 12/9/17.
//  Copyright © 2017 Pushkar Khedekar. All rights reserved.
//

import UIKit
import Firebase

class MyDocsTableViewController: UITableViewController {

    var user : User?
    var userID : String?
    var myList = [Document]()
    var indexArray = [String]()
    var document : Document?
    var docID : String?
    
    @IBAction func addDocumentPressed(_ sender: Any) {
        performSegue(withIdentifier: "toAddDocument", sender: self)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabCtrllr = self.tabBarController as! UserTabBarController
        user = tabCtrllr.user
        userID = tabCtrllr.userID
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
         retrieveList(userID!)
        super.viewWillAppear(animated)
       // self.tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    @IBAction func signOutPressed(_ sender: Any) {
       
        do {
            try Auth.auth().signOut()
        } catch let logError {
            print(logError)
        }
        
        performSegue(withIdentifier: "toSignOut", sender: self)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "docCell", for: indexPath) as! DocumentTableViewCell
        let document =  myList[indexPath.row]
        let docID = indexArray[indexPath.row]
        cell.documentID = docID
        cell.documentName.text = document.documentName
        cell.document = document
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

  

 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let addDoc = segue.destination as? AddDocumentViewController {
        addDoc.user = user
        addDoc.userID = userID
    }
    
    if let viewDocQR = segue.destination as? QRImageViewController {
        viewDocQR.document = document
        viewDocQR.docID = docID
    }
    
    if let viewDoc = segue.destination as? ViewDocumentViewController {
        viewDoc.document = document
    }
}
    
    
    func retrieveList(_ userID : String) {
        myList.removeAll()
        Database.database().reference().child("documentList").observe(.childAdded, with: {
            (snapshot) in
            if let docDictionary = snapshot.value as? [String : AnyObject]{
                let val = docDictionary["userID"] as! String
                if val == self.userID{
                self.indexArray.append(snapshot.key)
               let document = Document()
                document.setValuesForKeys(docDictionary)
                self.myList.append(document)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                }
            }
        }, withCancel: nil)
    }
 
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteItem = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let cell = tableView.cellForRow(at: indexPath) as! DocumentTableViewCell
            let documentID = cell.documentID
            Database.database().reference().child("documentList").child(documentID!).removeValue()
            self.retrieveList(self.userID!)
            self.tableView.reloadData()
            
        }
        
        let qrItem = UITableViewRowAction(style: .normal, title: "QR") { (action, indexPath) in
            let cell = tableView.cellForRow(at: indexPath) as! DocumentTableViewCell
            let document = cell.document
            self.document = document
            let docid = cell.documentID
            self.docID = docid
            
            self.performSegue(withIdentifier: "viewQRCode", sender: self)
        }
        
        let viewItem = UITableViewRowAction(style: .normal, title: "View"){ (action,indexPath) in
            let cell = tableView.cellForRow(at: indexPath) as! DocumentTableViewCell
            self.document = cell.document
            self.performSegue(withIdentifier: "toViewDoc", sender: self)
        }
        
        
        viewItem.backgroundColor = UIColor.init(red: 30/255, green: 30/255, blue: 180/255, alpha: 0.8)
        deleteItem.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 180/255, alpha: 0.8)
        qrItem.backgroundColor = UIColor.init(red: 60/255, green: 60/255, blue: 180/255, alpha: 0.8)
        return [deleteItem,viewItem,qrItem]
    }

}
