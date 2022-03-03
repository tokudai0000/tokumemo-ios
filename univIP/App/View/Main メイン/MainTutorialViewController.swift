//
//  TutorialSpotlightViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/12/23.
//

import Gecco

final class MainTutorialViewController: SpotlightViewController {
    
    // 各UILabelの座標データ
    public var uiLabels_frames:[CGRect] = []
    
    // 各TextLabelの文字列
    public var textLabels:[String] = []
    
    private var updateIndex = 0
    
    public var mainViewController: MainViewController?
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    
    // MARK: - Private
    private func createLabels() {
        // Labelのサイズ
        let width = CGFloat(200)
        let height = CGFloat(70)
        
        let label = UILabel()
        label.text = textLabels[updateIndex]
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.frame = CGRect(x: uiLabels_frames[updateIndex].minX - width, y: uiLabels_frames[updateIndex].minY - height,
                             width: width, height: height)
        self.view.addSubview(label)
    }
    
    private func createSpotlight() {
        // スポットライトのサイズ
        let width = CGFloat(75)
        let height = CGFloat(70)
        
        spotlightView.appear(Spotlight.RoundedRect(center: CGPoint(x: uiLabels_frames[updateIndex].midX, y: uiLabels_frames[updateIndex].midY),
                                                   size: CGSize(width: width, height: height),
                                                   cornerRadius: 50))
    }
}


// MARK: - SpotlightViewControllerDelegate
extension MainTutorialViewController: SpotlightViewControllerDelegate {

    //画面が表示される時
    func spotlightViewControllerWillPresent(_ viewController: SpotlightViewController, animated: Bool) {
        createLabels()
        createSpotlight()
    }
    //画面タップ時
    func spotlightViewControllerTapped(_ viewController: SpotlightViewController, tappedSpotlight: SpotlightType?) {
        updateIndex += 1
        if updateIndex == 2 {
            dismiss(animated: true, completion: nil)
            return
        }
        // 2個目のチュートリアル表示
        createLabels()
        createSpotlight()
    }
    
    //画面が消える時
    func spotlightViewControllerWillDismiss(_ viewController: SpotlightViewController, animated: Bool) {
        self.dismiss(animated: true, completion: {
            // メインスレッドで実行 UIの処理など
            let vc = R.storyboard.menu.menuViewController()!
            self.mainViewController?.present(vc, animated: true, completion: nil)
        })
        return
    }
    
}
