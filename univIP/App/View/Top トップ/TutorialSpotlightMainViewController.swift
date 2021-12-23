//
//  TutorialSpotlightViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/12/23.
//

import Gecco

final class TutorialSpotlightMainViewController: SpotlightViewController {
    
    //各UILabelの座標データ
    var uiLabels_frames:[CGRect] = []
    //画面サイズ
    let screenSize = UIScreen.main.bounds.size
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    // メッセージ用のUILabelを生成
    private func createLabels() {
        let label = UILabel()
        label.text = "ここからショートカット機能を利用できます"
        //labelの設定
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.frame = CGRect(x: self.view.frame.width - 170, y: self.view.frame.height - 120, width: 170, height: 60)
        self.view.addSubview(label)
    }
    
    private func nextSpotlight() {
        spotlightView.appear(Spotlight.RoundedRect(center: CGPoint(x: uiLabels_frames[0].minX, y: uiLabels_frames[0].minY),
                                                   size: CGSize(width: 20, height: 20),
                                                   cornerRadius: 50))
    }
    
}

extension TutorialSpotlightMainViewController: SpotlightViewControllerDelegate {
    
    //画面が表示される時
    func spotlightViewControllerWillPresent(_ viewController: SpotlightViewController, animated: Bool) {
        createLabels()
        nextSpotlight()
    }
    
    //画面タップ時
    func spotlightViewControllerWillDismiss(_ viewController: SpotlightViewController, animated: Bool) {
        return
    }
    
    //画面が消える時
    func spotlightViewControllerTapped(_ viewController: SpotlightViewController, tappedSpotlight: SpotlightType?) {
        spotlightView.disappear()
        self.dismiss(animated: true, completion: nil)
//        let vc = R.storyboard.menu.menuViewController()!
//        self.present(vc, animated: true, completion: nil)
    }
    
}
