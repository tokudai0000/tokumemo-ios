//
//  SearchViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit

class SyllabusViewController: UIViewController {
    //MARK:- @IBOutlet
    @IBOutlet weak var subjectNameTextField: UITextField!
    @IBOutlet weak var teacherNameTextField: UITextField!
    @IBOutlet weak var keyWordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK:- @IBAction
    @IBAction func searchButton(_ sender: Any) {
        /*  button.Tag
         11.検索
         12.詳細に検索
         */
        let vc = R.storyboard.webView.webViewController()!
        
        if let button = sender as? UIButton {
//            vc.buttonTagValue = button.tag
        }
        if let subjectName = subjectNameTextField.text{
//            vc.subjectName = subjectName
        }
        if let teacherName = teacherNameTextField.text{
//            vc.teacherName = teacherName
        }
        if let keyWord = keyWordTextField.text{
//            vc.keyWord = keyWord
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func homeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
