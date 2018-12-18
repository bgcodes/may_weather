//
//  TableViewCell.swift
//  may_weather
//
//  Created by Grzegorz Bogdan on 18/12/2018.
//  Copyright © 2018 Grzegorz Bogdan. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var CellTemperatureLabel: UILabel!
    @IBOutlet weak var CellTownLabel: UILabel!
    @IBOutlet weak var CellImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
