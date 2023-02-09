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
    @IBOutlet weak var textView: UITextView!
    
    private let dataManager = DataManager.singleton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 学生番号を定義する
        let studentNumber = dataManager.cAccount

        // バーコードを生成する
        let GeneratedImage = BarCodeGenerator.generateBarCode(from: "\(studentNumber)0")

        // 生成した画像を読み込む
        BarCodeImageView.image = GeneratedImage

        // Labelを変更
        StudentNumberLabel.text = "A\(studentNumber)0A"
        
        let filePath = R.file.studentNumberDiscriptionRtf()!
        textView.attributedText = Common.loadRtfFileContents(filePath)
        
    }

}
