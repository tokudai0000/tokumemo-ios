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
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private var buttonTagValue = ""
    private var subjectName = ""
    private var teacherName = ""
    private var keyWord = ""
    
    //MARK:- @IBAction
    @IBAction func searchButton(_ sender: Any) {
        /*  button.Tag
         11.検索
         12.詳細に検索
         */
        
        if let button = sender as? UIButton {
            buttonTagValue = String(button.tag)
        }
        if let subN = subjectNameTextField.text{
            subjectName = subN
        }
        if let teaN = teacherNameTextField.text{
            teacherName = teaN
        }
        if let keyW = keyWordTextField.text{
            keyWord = keyW
        }
        
        delegateMain?.reloadSyllabus(subN: subjectName, teaN: teacherName, keyW: keyWord, buttonTV: buttonTagValue)
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Override
    // キーボード非表示
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
