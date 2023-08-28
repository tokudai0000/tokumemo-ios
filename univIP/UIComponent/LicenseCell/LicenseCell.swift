//
//  LicenseCell.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/23.
//

import UIKit
import Entity

public class LicenseCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var licenseLabel: UILabel!
    @IBOutlet weak var textView: UITextView!

    public func configure(item: AcknowledgementsItemModel) {
        titleLabel.text = item.title
        licenseLabel.text = item.license
        textView.text = item.contentsText
        textView.isScrollEnabled = false
    }
}
