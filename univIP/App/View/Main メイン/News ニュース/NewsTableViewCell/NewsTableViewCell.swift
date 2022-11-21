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
    @IBOutlet weak var newsImageView: UIImageView!
    
    func setupCell(text: String, date: String, urlStr: String) {
        contentsLabel.text = text
        dateLabel.text = date
        newsImageView.cacheImage(imageUrlString: urlStr)
    }
    
}
