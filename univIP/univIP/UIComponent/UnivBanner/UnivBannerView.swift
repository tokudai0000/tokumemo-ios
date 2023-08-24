//
//  UnivBannerView.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/07/15.
//

import UIKit

class UnivBannerView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextView: UILabel!
    @IBOutlet weak var discriptionTextView: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
