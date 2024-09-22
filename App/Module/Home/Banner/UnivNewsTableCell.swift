//
//  UnivNewsTableCell.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/11/10.
//

import UIKit
import NorthLayout

final class UnivNewsTableCell: UITableViewCell {
    static let Reusable = "UnivNewsTableCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    private let createdAtLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 8, weight: .semibold)
        label.textAlignment = .left
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

    func setup(_ item: NewsItemModel) {
        titleLabel.text = item.title
        createdAtLabel.text = item.createdAt
    }

    private func setupUI() {
        let autolayout = contentView.northLayoutFormat([:], [
            "title": titleLabel,
            "createdAt": createdAtLabel
        ])
        autolayout("H:|-10-[title]-5-|")
        autolayout("H:|-15-[createdAt]|")
        autolayout("V:|-10-[title(>=40)]-10-[createdAt]-5-|")
    }
}
