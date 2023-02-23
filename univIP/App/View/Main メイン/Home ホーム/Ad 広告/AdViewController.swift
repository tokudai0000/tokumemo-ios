//
//  AdViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/12/16.
//

import UIKit

class AdViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var button: UIButton!
    
    public var imageUrlStr = ""
    public var introductionText = ""
    public var urlStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.loadCacheImage(urlStr: imageUrlStr)
        textView.text = introductionText
    }
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func button(_ sender: Any) {
        let vc = R.storyboard.web.webViewController()!
        vc.loadUrlString = urlStr
        present(vc, animated: true, completion: nil)
    }
}
