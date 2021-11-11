//
//  GroceryListTableViewCell.swift
//  Grocery List
//
//  Created by administrator on 10/11/2021.
//

import UIKit

class GroceryListTableViewCell: UITableViewCell {
    @IBOutlet weak var nameitem: UILabel!
    @IBOutlet weak var nameEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
