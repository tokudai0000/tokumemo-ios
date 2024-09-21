//
//  ThirdPartyCreditCell.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/23.
//

import UIKit
import NorthLayout

final class ThirdPartyCreditCell: UITableViewCell {
    static let Reusable = "ThirdPartyCreditCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        return label
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 8, weight: .thin)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    var tapHandler: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(_ item: CreditItemModel) {
        titleLabel.text = item.title
        contentLabel.text = item.contentsText
    }

    private func setupUI() {
        let autolayout = contentView.northLayoutFormat([:], [
            "title": titleLabel,
            "content": contentLabel
        ])
        autolayout("H:|[title]|")
        autolayout("H:|[content]|")
        autolayout("V:|-10-[title]-10-[content]|")
    }
}
