//
//  FavoriteViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/02/16.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var favoriteTextSizeLabel: UILabel!
    @IBOutlet weak var favoriteNameTextField: UITextField!
    @IBOutlet weak var isFirstViewSetting: UISwitch!
    
    public var urlString = "nil"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlLabel.text = urlString
    }

    // MARK: - IBAction
    @IBAction func registerButton(_ sender: Any) {
    }
    
}
