//
//  OrderCell.swift
//  tipME
//
//  Created by Derek Chang on 11/10/19.
//  Copyright © 2019 Derek Chang. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {

    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
