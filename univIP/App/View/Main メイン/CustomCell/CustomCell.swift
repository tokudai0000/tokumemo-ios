//
//  CustomCell.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/10/12.
//

import UIKit

class CustomCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func setupCell(string: String) {
        iconImageView.image = R.image.mainIconColor()//UIImage(named: R.image.mainIconColor)
        nameLabel.text = string
        
    }
}
