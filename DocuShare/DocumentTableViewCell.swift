//
//  DocumentTableViewCell.swift
//  DocuShare
//
//  Created by Georgeena Thomas on 12/13/17.
//  Copyright © 2017 Pushkar Khedekar. All rights reserved.
//

import UIKit

class DocumentTableViewCell: UITableViewCell {

    @IBOutlet weak var documentName: UILabel!
    var documentID : String?
    var document : Document?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
