//
//  LicenseCell.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/23.
//

import UIKit

class LicenseCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var licenseLabel: UILabel!
    @IBOutlet weak var textView: UITextView!

    func configure(item: AcknowledgementsItemModel) {
        titleLabel.text = item.title
        licenseLabel.text = item.license
        textView.text = item.contentsText
        textView.isScrollEnabled = false
    }
}
