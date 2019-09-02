//
//  SlidingSavedHikesTableViewCell.swift
//  Trekker
//
//  Created by Jason Mandozzi on 9/2/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class SlidingSavedHikesTableViewCell: UITableViewCell {

    @IBOutlet weak var hikeNameLabel: UILabel!
    @IBOutlet weak var hikeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
