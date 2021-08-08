//
//  SyllabusViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/06.
//

import UIKit

class SyllabusViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func homeButton(_ sender: Any) {
        let vc = R.storyboard.main.mainViewController()!
        self.present(vc, animated: true, completion: nil)
    }
    
}
