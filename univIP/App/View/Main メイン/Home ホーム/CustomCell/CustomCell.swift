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
    
    func setupCell(string: String, image: UIImage?) {
        nameLabel.text = string
        iconImageView.image = image
    }
}
