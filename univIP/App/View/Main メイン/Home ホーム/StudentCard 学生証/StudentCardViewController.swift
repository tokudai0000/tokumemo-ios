//
//  StudentCardViewController.swift
//  univIP
//
//  Created by Keita Miyake on 2022/10/26.
//

import UIKit

class StudentCardViewController: UIViewController {

    @IBOutlet weak var BarCodeImageView: UIImageView!
    @IBOutlet weak var StudentNumberLabel: UILabel!
    
    // バーコードを生成する
    let GeneratedImage = BarCodeGenerator.generateBarCode(from: "1234567890")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 画像を読み込む
        BarCodeImageView.image = GeneratedImage
        
        // Labelを変更
        StudentNumberLabel.text = "A1234567890A"
        
    }

}
