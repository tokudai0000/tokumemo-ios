//
//  NewsTableViewCell.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/11/10.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func setupCell(text: String, date: String) {
        contentsLabel.text = text
        dateLabel.text = date
    }
}
