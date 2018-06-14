//
//  OtherProfileBusinessTableViewCell.swift
//  FooFulu
//
//  Created by netset on 05/02/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit

class OtherProfileBusinessTableViewCell: UITableViewCell {
	//MARK:- OUTLET(S)
	@IBOutlet weak var addressLabel: UILabel!
	@IBOutlet weak var ratingCountlabel: UILabel!
	@IBOutlet weak var businessTitleLabel: UILabel!
	@IBOutlet weak var businessImage: UIImageView!
	@IBOutlet weak var businessRatingView: FloatRatingView!
	@IBOutlet weak var headerCellTapButton:UIButton!
	
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
