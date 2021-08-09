//
//  ViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/06.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func CMButton(_ sender: Any) {
        let vc = R.storyboard.courseManagement.cmViewController()!
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func ManabaButton(_ sender: Any) {
        let vc = R.storyboard.manaba.manabaViewController()!
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
    
    @IBAction func LibraryButton(_ sender: Any) {
        let vc = R.storyboard.library.libraryViewController()!
        self.present(vc, animated: true, completion: nil)
    }
    
    
}

