//
//  PRViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/12/16.
//

import UIKit

class PRViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var detailsInfoButton: UIButton!
    
    public var item: PrData!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        textView.cornerRound = 15
//        detailsInfoButton.cornerRound = 20
        guard let url = item.imageURL,
              let intro = item.explanation else{
            return
        }
        imageView.loadCacheImage(urlStr: url)
        textView.text = intro
    }
    
    // MARK: - IBAction
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func detailsInfoButton(_ sender: Any) {
        guard let url = item.tappedURL else{
            return
        }
        let vc = R.storyboard.web.webViewController()!
        vc.loadUrlString = url
        present(vc, animated: true, completion: nil)
    }
}
