//
//  CustomLabelTableHeader.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/2/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit

class CustomLabelTableHeader: UIView {

    @IBOutlet weak var headerLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headerLabel.preferredMaxLayoutWidth = headerLabel.bounds.width
    }
    
}
