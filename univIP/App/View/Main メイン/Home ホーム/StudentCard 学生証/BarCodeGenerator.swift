//
//  BarCodeGenerator.swift
//  univIP
//
//  Created by Keita Miyake on 2022/10/31.
//

import UIKit
import ZXingObjC

class BarCodeGenerator {

    static public func generateBarCode(from string: String) -> UIImage? {
        do {
            let writer = ZXMultiFormatWriter()
            let hints = ZXEncodeHints() as ZXEncodeHints
            let result = try writer.encode(string, format: kBarcodeFormatCodabar, width: 150, height: 45, hints: hints)

            if let imageRef = ZXImage.init(matrix: result) {
                if let image = imageRef.cgimage {
                    return UIImage.init(cgImage: image)
                }
            }
        }
        catch {
            print(error)
        }
        return nil
    }
}

