//
//  TutorialSpotlightMenuViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/12/23.
//

import Gecco

final class TutorialSpotlightMenuViewController: SpotlightViewController {
    
    //各UILabelの座標データ
    public var uiLabels_frames:[CGRect] = []
    
    public var delegateMenu : MenuViewController?
    
    private let label = UILabel()
    
    private var updateIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        spotlightView.delegate = self
        delegate = self
    }
    
    // メッセージ用のUILabelを生成
    private func createLabels() {
        // Labelのサイズ**可変**
        let width = CGFloat(250)
        let height = CGFloat(80)
        
        switch updateIndex {
            case 0:
                label.text = "パスワードを入力し、自動ログイン機能を活用しましよう"
            case 1:
                label.text = "他にも学部に依ってさまざまなカスタマイズをしましょう"
            default:
                break
        }
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.frame = CGRect(x: uiLabels_frames[0].minX, y: uiLabels_frames[0].minY + height + 20,
                             width: width, height: height)
        self.view.addSubview(label)
    }
    
    private func createSpotlight() {
        // スポットライトのサイズ**可変**
        let width = uiLabels_frames[0].width + 25
        let height = uiLabels_frames[0].height + 25
        var posY = CGFloat()
        
        switch updateIndex {
            case 0:
                posY = uiLabels_frames[0].midY
                
            case 1:
                posY = uiLabels_frames[1].midY
                
            default:
                dismiss(animated: true, completion: nil)
                return
        }
        
        spotlightView.appear(Spotlight.RoundedRect(center: CGPoint(x: uiLabels_frames[1].midX, y: posY),
                                                   size: CGSize(width: width, height: height),
                                                   cornerRadius: 50))
        
        updateIndex += 1
        
    }
    
}


extension TutorialSpotlightMenuViewController: SpotlightViewControllerDelegate {
    
    //画面が表示される時
    func spotlightViewControllerWillPresent(_ viewController: SpotlightViewController, animated: Bool) {
        createLabels()
        createSpotlight()
    }
    //画面タップ時
    func spotlightViewControllerTapped(_ viewController: SpotlightViewController, tappedSpotlight: SpotlightType?) {
        // 2個目のチュートリアル表示
        createLabels()
        createSpotlight()
    }
    
    //画面が消える時
    func spotlightViewControllerWillDismiss(_ viewController: SpotlightViewController, animated: Bool) {
        delegateMenu?.dismiss(animated: true, completion: nil)
        return
    }
    
}
