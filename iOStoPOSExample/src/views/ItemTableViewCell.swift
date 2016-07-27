//
//  ItemTableViewCell.swift
//  TCPTest
//
//  Created by Eric McConkie on 2/24/16.
//  Copyright © 2016 poynt.co. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSub: UILabel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
