//
//  CustomDuoButton.swift
//  AkidonComponents
//
//  Created by Akihiro Matsuyama on 2024/03/15.
//

import UIKit

class CustomDuoButton: UIButton {
    var onTap: ((Int) -> Void)?

    init(title: String,
                textColor: UIColor = .black,
                backgroundColor: UIColor = .white,
                borderColor: UIColor = .systemBlue,
                fontSize: CGFloat = 18,
                tag: Int = 0,
                verticalMargin: CGFloat = 25,
                horizontalMargin: CGFloat = 50) {
        super.init(frame: .zero)

        self.setTitle(title, for: .normal)
        self.setTitleColor(textColor, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: fontSize, weight: .semibold)
        self.tag = tag
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1.5
        self.layer.borderColor = borderColor.cgColor
        self.layer.shadowColor = borderColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 0
        self.layer.shadowOpacity = 1
        self.translatesAutoresizingMaskIntoConstraints = false
        self.sizeToFit()

        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: self.frame.width + horizontalMargin),
            self.heightAnchor.constraint(equalToConstant: self.frame.height + verticalMargin),
        ])

        self.addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        self.addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside])
        self.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func buttonPressed() {
        UIView.animate(withDuration: 0.2) {
            self.layer.shadowOpacity = 0
            self.transform = CGAffineTransform(translationX: 0, y: 2)
        }
    }

    @objc private func buttonReleased() {
        UIView.animate(withDuration: 0.2) {
            self.layer.shadowOpacity = 1
            self.transform = CGAffineTransform.identity
        }
    }

    @objc func buttonTapped(_ sender: UIButton) {
        onTap?(sender.tag)
    }
}
