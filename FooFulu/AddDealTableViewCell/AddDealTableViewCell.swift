//
//  AddDealTableViewCell.swift
//  FooFulu
//
//  Created by netset on 25/01/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit

class AddDealTableViewCell: UITableViewCell {
	//MARK:- OUTLET(S)
	@IBOutlet weak var hotelImage: FooFuluUIImageView!
	@IBOutlet weak var hotelName: UILabel!
	@IBOutlet weak var address: UILabel!
	@IBOutlet weak var distance: UILabel!
	//MARK:- LIFE CYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
