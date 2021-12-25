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
    
    private let label = UILabel()
    private let dataManager = DataManager.singleton
    
    private var updateIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    // メッセージ用のUILabelを生成
    private func createLabels() {
        switch updateIndex {
            case 0:
                label.text = "ここからパスワードを入力できます"
            case 1:
                label.text = "ここからカスタマイズできます"
            default:
                break
        }
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.frame = CGRect(x: 0, y: uiLabels_frames[updateIndex].origin.y + uiLabels_frames[updateIndex].height + 20, width: uiLabels_frames[updateIndex].width, height: 60)
        self.view.addSubview(label)
    }
    
    private func nextSpotlight() {
        
        switch updateIndex {
            case 0:
                spotlightView.appear(Spotlight.RoundedRect(center: CGPoint(x: uiLabels_frames[0].minX + 30, y: uiLabels_frames[0].minY - 10),
                                                           size: CGSize(width: uiLabels_frames[0].width/2, height: uiLabels_frames[0].height),
                                                           cornerRadius: 50))
                
            case 1:
                spotlightView.appear(Spotlight.RoundedRect(center: CGPoint(x: uiLabels_frames[1].minX + 30, y: uiLabels_frames[1].minY - 10),
                                                           size: CGSize(width: uiLabels_frames[1].width/2, height: uiLabels_frames[1].height),
                                                           cornerRadius: 50))
            default:
                break
        }
        updateIndex += 1
        
    }
    
}


extension TutorialSpotlightMenuViewController: SpotlightViewControllerDelegate {
    
    //画面が表示される時
    func spotlightViewControllerWillPresent(_ viewController: SpotlightViewController, animated: Bool) {
        createLabels()
        nextSpotlight()
    }
    //画面タップ時
    func spotlightViewControllerTapped(_ viewController: SpotlightViewController, tappedSpotlight: SpotlightType?) {
        if updateIndex == 2 {
            dataManager.isFinishedMainTutorial = true
            spotlightView.disappear()
            dismiss(animated: true, completion: nil)
            return
        }
        createLabels()
        nextSpotlight()
    }
    
    //画面が消える時
    func spotlightViewControllerWillDismiss(_ viewController: SpotlightViewController, animated: Bool) {
        return
    }
    
}
