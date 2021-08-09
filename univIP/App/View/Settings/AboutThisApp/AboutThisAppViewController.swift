//
//  AboutThisAppViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//

import UIKit

class AboutThisAppViewController: UIViewController {

    
    @IBOutlet weak var textView: UITextView!
    
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
    

    @IBAction func homeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
