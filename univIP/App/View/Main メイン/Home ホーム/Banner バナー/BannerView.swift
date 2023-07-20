//
//  BannerView.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/07/14.
//

import UIKit

class BannerView: UIView {

    @IBOutlet weak var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
