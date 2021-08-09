//
//  SearchViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//

import UIKit

class SearchViewController: UIViewController {

    
    @IBOutlet weak var subjectNameTextField: UITextField!
    @IBOutlet weak var teacherNameTextField: UITextField!
    @IBOutlet weak var keyWordTextField: UITextField!
    @IBOutlet weak var backButton: UIBarButtonItem!{
        didSet {
            backButton.isEnabled = false
            backButton.tintColor = UIColor.blue.withAlphaComponent(0.4)
        }
    }
    @IBOutlet weak var forwardButton: UIBarButtonItem! {
        didSet {
            forwardButton.isEnabled = false
            forwardButton.tintColor = UIColor.blue.withAlphaComponent(0.4)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK:- @IBAction
    @IBAction func searchButton(_ sender: Any) {
        /*
         11.検索
         12.詳細に検索
         */
        let vc = R.storyboard.webView.webViewController()!
        if let button = sender as? UIButton {
            vc.passByValue = button.tag
        }
        vc.subjectName = subjectNameTextField.text ?? ""
        vc.teacherName = teacherNameTextField.text ?? ""
        vc.keyWord = keyWordTextField.text ?? ""
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func homeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
//        let vc = R.storyboard.main.mainViewController()!
//        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func itemButton(_ sender: Any) {
//        toolBar.isHidden = true
    }
    
    
}
