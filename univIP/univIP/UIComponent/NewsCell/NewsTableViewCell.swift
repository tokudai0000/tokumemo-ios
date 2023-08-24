//
//  NewsTableViewCell.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/11/10.
//

import UIKit
import Entity

class NewsTableViewCell: UITableViewCell {
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configure(model: NewsItemModel) {
        contentsLabel.text = model.title
        dateLabel.text = model.createdAt
    }
}
