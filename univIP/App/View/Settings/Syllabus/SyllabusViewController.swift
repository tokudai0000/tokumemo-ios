//
//  SearchViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit

class SyllabusViewController: BaseViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var subjectNameTextField: UITextField!
    @IBOutlet weak var teacherNameTextField: UITextField!
    @IBOutlet weak var keyWordTextField: UITextField!
    
    var delegateMain : MainViewController?
    
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchButton.layer.cornerRadius = 20.0
    }
    
    
    //MARK:- IBAction
    @IBAction func searchButton(_ sender: Any) {
        var subjectName = ""
        var teacherName = ""
        var keyWord = ""
        
        if let subN = subjectNameTextField.text{
            subjectName = subN
        }
        if let teaN = teacherNameTextField.text{
            teacherName = teaN
        }
        if let keyW = keyWordTextField.text{
            keyWord = keyW
        }
        
        delegateMain?.refreshSyllabus(subjectName: subjectName, teacherName: teacherName, keyword: keyWord)
        self.dismiss(animated: true, completion: nil)
    }
}
