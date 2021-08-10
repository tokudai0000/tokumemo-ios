//
//  ViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/06.
//  Copyright © 2021年　akidon0000
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:- @IBAction
    @IBAction func toWebButton(_ sender: Any) {
        /*  button.tag
         1. 教務事務システム CMViewController
         2. マナバ　ManabaViewController
         3. 図書館 LiburaryViewController
         */
        let vc = R.storyboard.webView.webViewController()!
        if let button = sender as? UIButton {
            vc.buttonTagValue = button.tag
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func SyllabusButton(_ sender: Any) {
        let vc = R.storyboard.syllabus.syllabusViewController()!
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func SettingsButton(_ sender: Any) {
        let vc = R.storyboard.settings.settingsViewController()!
        self.present(vc, animated: true, completion: nil)
    }
    
}

