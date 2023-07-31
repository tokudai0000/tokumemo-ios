//
//  String.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/01/03.
//

extension String {
    // 左から文字埋めする UIColorのtoHexStringしか使っていない
    func leftPadding(toLength: Int, withPad character: Character) -> String {
        let stringLength = self.count
        if stringLength < toLength {
            return String(repeatElement(character, count: toLength - stringLength)) + self
        } else {
            return String(self.suffix(toLength))
        }
    }
}
