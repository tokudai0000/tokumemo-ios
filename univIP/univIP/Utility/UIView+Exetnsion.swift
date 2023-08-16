//
//  UIView.swift
//  univIP
//
//  Created by Keita Miyake on 2022/10/24.
//

import UIKit

extension UIView {
  /// 枠線の色
  @IBInspectable var borderColor: UIColor? {
    get {
      layer.borderColor.map { UIColor(cgColor: $0) }
    }
    set {
      layer.borderColor = newValue?.cgColor
    }
  }

  /// 枠線のWidth
  @IBInspectable var borderWidth: CGFloat {
    get {
      layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }

  /// 角丸の大きさ
  @IBInspectable var cornerRound: CGFloat {
    get {
      layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
      layer.masksToBounds = newValue > 0
    }
  }
}
