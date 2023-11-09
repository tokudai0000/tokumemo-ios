//
//  ThirdPartyCreditCell.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/23.
//

import UIKit
import Entity
import Ikemen
import NorthLayout

final class ThirdPartyCreditCell: UITableViewCell {
    static let Reusable = "ThirdPartyCreditCell"
    
    private let titleLabel = UILabel() ※ {
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textAlignment = .center
    }
    private let contentLabel = UILabel() ※ {
        $0.font = .systemFont(ofSize: 8, weight: .thin)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

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
