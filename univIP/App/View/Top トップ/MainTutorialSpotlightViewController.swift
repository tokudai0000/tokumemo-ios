//
//  TutorialSpotlightViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/12/23.
//

import Gecco

final class MainTutorialSpotlightViewController: SpotlightViewController {
    
    //各UILabelの座標データ
    public var uiLabels_frames:[CGRect] = []
    
    private let label = UILabel()
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    
    // MARK: - Private
    private func createLabels() {
        // Labelのサイズ**可変**
        let width = CGFloat(200)
        let height = CGFloat(70)
        
        label.text = "ここからメニューを\n表示できます"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.frame = CGRect(x: uiLabels_frames[0].minX - width, y: uiLabels_frames[0].minY - height,
                             width: width, height: height)
        self.view.addSubview(label)
    }
    
    private func createSpotlight() {
        // スポットライトのサイズ**可変**
        let width = uiLabels_frames[0].width + 25
        let height = uiLabels_frames[0].height + 25
        
        spotlightView.appear(Spotlight.RoundedRect(center: CGPoint(x: uiLabels_frames[0].midX, y: uiLabels_frames[0].midY),
                                                   size: CGSize(width: width, height: height),
                                                   cornerRadius: 50))
    }
    
}


// MARK: - SpotlightViewControllerDelegate
extension MainTutorialSpotlightViewController: SpotlightViewControllerDelegate {
    
    //画面が表示される時
    func spotlightViewControllerWillPresent(_ viewController: SpotlightViewController, animated: Bool) {
        createLabels()
        createSpotlight()
    }
    
    //画面タップ時
    func spotlightViewControllerTapped(_ viewController: SpotlightViewController, tappedSpotlight: SpotlightType?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //画面が消える時
    func spotlightViewControllerWillDismiss(_ viewController: SpotlightViewController, animated: Bool) {
        return
    }
    
}
