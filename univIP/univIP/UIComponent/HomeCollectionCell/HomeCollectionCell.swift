//
//  HomeCollectionCell.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/10/12.
//

import UIKit

class HomeCollectionCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setupCell(title: String, image: UIImage) {
        titleLabel.text = title
        iconImageView.image = image
    }
}
