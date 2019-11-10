//
//  NameCell.swift
//  tipME
//
//  Created by Derek Chang on 11/10/19.
//  Copyright © 2019 Derek Chang. All rights reserved.
//

import UIKit

class NameCell: UITableViewCell {

    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var personPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
