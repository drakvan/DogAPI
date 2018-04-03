//
//  TableViewCell.swift
//  DogAPI
//
//  Created by Ivan Cabrer on 4/3/18.
//  Copyright © 2018 drakvan. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var tlBreed: UILabel!
    @IBOutlet weak var imagePhoto: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
