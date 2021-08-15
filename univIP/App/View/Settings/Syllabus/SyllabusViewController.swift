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
    
    var delegateMain : MainViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var buttonTagValue = ""
    var subjectName = ""
    var teacherName = ""
    var keyWord = ""
    
    //MARK:- @IBAction
    @IBAction func searchButton(_ sender: Any) {
        /*  button.Tag
         11.検索
         12.詳細に検索
         */
//        let vc = R.storyboard.webView.webViewController()!
        
        if let button = sender as? UIButton {
            buttonTagValue = String(button.tag)
        }
        if let subjectName1 = subjectNameTextField.text{
            subjectName = subjectName1
        }
        if let teacherName1 = teacherNameTextField.text{
            teacherName = teacherName1
        }
        if let keyWord1 = keyWordTextField.text{
            keyWord = keyWord1
        }
        delegateMain?.reloadSyllabus(subN: subjectName, teaN: teacherName, keW: keyWord)
        self.dismiss(animated: true, completion: nil)
        
//        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK:- Override
    // キーボード非表示
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
