//
//  TutorialSpotlightViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/12/23.
//

import UIKit
import Gecco

class TutorialSpotlightMainViewController: SpotlightViewController, SpotlightViewControllerDelegate {
    
    //各UILabelの座標データ
    var uiLabels_frames = [CGRect()]
    //画面サイズ
    let screenSize = UIScreen.main.bounds.size
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    //画面が表示される時
    func spotlightViewControllerWillPresent(_ viewController: SpotlightViewController, animated: Bool) {
        return
    }
    //画面タップ時
    func spotlightViewControllerWillDismiss(_ viewController: SpotlightViewController, animated: Bool) {
        return
    }
    //画面が消える時
    func spotlightViewControllerTapped(_ viewController: SpotlightViewController, tappedSpotlight: SpotlightType?) {
        spotlightView.disappear()
        dismiss(animated: true, completion: nil)
    }
    
}
