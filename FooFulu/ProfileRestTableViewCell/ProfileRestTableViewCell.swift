//
//  ProfileRestTableViewCell.swift
//  FooFulu
//
//  Created by netset on 01/02/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit

class ProfileRestTableViewCell: UITableViewCell {

	@IBOutlet weak var ratingView: FloatRatingView!
	@IBOutlet weak var headerCellDidTapButton: UIButton!
	@IBOutlet weak var dealNameLabel: UILabel!
	@IBOutlet weak var businessReviewsCountLabel: UILabel!
	@IBOutlet weak var businessTitle: UILabel!
	@IBOutlet weak var businessImage: UIImageView!
	override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
	
	
}
