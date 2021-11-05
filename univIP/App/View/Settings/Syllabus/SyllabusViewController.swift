//
//  SearchViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit

final class SyllabusViewController: BaseViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var subjectNameTextField: UITextField!
    @IBOutlet weak var teacherNameTextField: UITextField!
    @IBOutlet weak var keyWordTextField: UITextField!
    
    public var delegate : MainViewController?
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    
    // MARK: - IBAction
    @IBAction func searchButton(_ sender: Any) {
        
        delegate?.refreshSyllabus(subjectName: subjectNameTextField.text ?? "",
                                      teacherName: teacherNameTextField.text ?? "",
                                      keyword: keyWordTextField.text ?? "")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Private func
    private func setup() {
        
        searchButton.layer.cornerRadius = 20.0
    }
}
