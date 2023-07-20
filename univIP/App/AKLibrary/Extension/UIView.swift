//
//  UIView.swift
//  univIP
//
//  Created by Keita Miyake on 2022/10/24.
//

import UIKit.UIView

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

//  /// 影の色
//  @IBInspectable var shadowColor: UIColor? {
//    get {
//      layer.shadowColor.map { UIColor(cgColor: $0) }
//    }
//    set {
//      layer.shadowColor = newValue?.cgColor
//      layer.masksToBounds = false
//    }
//  }
//
//  /// 影の透明度
//  @IBInspectable var shadowAlpha: Float {
//    get {
//      layer.shadowOpacity
//    }
//    set {
//      layer.shadowOpacity = newValue
//    }
//  }
//
//  /// 影のオフセット
//  @IBInspectable var shadowOffset: CGSize {
//    get {
//      layer.shadowOffset
//    }
//    set {
//      layer.shadowOffset = newValue
//    }
//  }
//
//  /// 影のぼかし量
//  @IBInspectable var shadowRadius: CGFloat {
//    get {
//      layer.shadowRadius
//    }
//    set {
//      layer.shadowRadius = newValue
//    }
//  }
}
