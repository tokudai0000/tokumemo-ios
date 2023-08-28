//
//  UnivBannerView.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/07/15.
//

import UIKit

public class UnivBannerView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextView: UILabel!
    @IBOutlet weak var discriptionTextView: UILabel!

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
