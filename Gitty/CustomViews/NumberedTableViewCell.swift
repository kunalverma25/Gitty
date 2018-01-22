//
//  NumberedTableViewCell.swift
//  Gitty
//
//  Created by upandrarai on 21/01/18.
//  Copyright © 2018 Kunal. All rights reserved.
//

import UIKit

class NumberedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellIndicatorImageView: UIImageView!
    
    func configureCell(_ cellData: ProfileCellData) {
        
        titleLabel.text = cellData.title
        numberLabel.text = cellData.number
        
        guard let imageName = cellData.imageName else { return }
        cellImageView.image = UIImage(named: imageName)
    }
    
}
