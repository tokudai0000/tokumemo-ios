//
//  SearchViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//

import UIKit

class SearchViewController: UIViewController {

    
    @IBOutlet weak var subjectName: UITextField!
    @IBOutlet weak var teacherName: UITextField!
    @IBOutlet weak var keyWord: UITextField!
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
        let vc = R.storyboard.syllabus.syllabusViewController()!
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func detailSearchButton(_ sender: Any) {
    }
    
    @IBAction func goBackButton(_ sender: Any) {
//        webView.goBack()
    }
    
    @IBAction func goForwardButton(_ sender: Any) {
//        webView.goForward()
    }
    
    @IBAction func homeButton(_ sender: Any) {
        let vc = R.storyboard.main.mainViewController()!
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func itemButton(_ sender: Any) {
//        toolBar.isHidden = true
    }
    
    
}
