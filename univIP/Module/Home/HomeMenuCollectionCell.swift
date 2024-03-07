//
//  HomeMenuCollectionCell.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/10/12.
//

import UIKit
import Entity
import NorthLayout

final class HomeMenuCollectionCell: UICollectionViewCell {
    static let Reusable = "HomeMenuCollectionCell"

    private let imageView = UIImageView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        return label
    }()


    var tapHandler: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(_ item: MenuItem) {
        imageView.image = item.icon
        titleLabel.text = item.title
    }

    private func setupUI() {
        let autolayout = contentView.northLayoutFormat([:], [
            "image": imageView,
            "title": titleLabel
        ])
        autolayout("H:||-(>=0)-[image(50)]-(>=0)-||")
        autolayout("H:|[title]|")
        autolayout("V:|-10-[image(50)]-10-[title]-10-|")

        layoutMarginsGuide.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
    }
}
