//
//  TutorialSpotlightMenuViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/12/23.
//

import Gecco

final class MenuTutorialSpotlightViewController: SpotlightViewController {
    
    //各UILabelの座標データ
    public var uiLabels_frames:[CGRect] = []
    
    public var delegateMenu : MenuViewController?
    
    private let label = UILabel()
    
    private var updateIndex = 0
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    
    // MARK: - Private
    private func createLabels() {
        // Labelのサイズ**可変**
        let width = CGFloat(250)
        let height = CGFloat(80)
        
        switch updateIndex {
            case 0:
                label.text = "パスワードを入力し、自動ログイン機能を活用しましよう"
            case 1:
                label.text = "他にも、さまざまなカスタマイズを試してみましょう"
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
        let width = uiLabels_frames[0].width
        let height = uiLabels_frames[0].height
        var posY = CGFloat()
        print(uiLabels_frames[0])
        print(uiLabels_frames[0].minY)
        print(uiLabels_frames[0].midY)
        print(uiLabels_frames[0].maxY)
        
        print(uiLabels_frames[1])
        print(uiLabels_frames[1].minY)
        print(uiLabels_frames[1].midY)
        print(uiLabels_frames[1].maxY)
        
        //上部のSafeArea
        let safeAreaTop = 47 - self.view.safeAreaInsets.top
        print(safeAreaTop)
        
        
        /*
         5.5inch
         (119.0, 552.0, 290.0, 44.0)
         552.0
         574.0
         596.0
         (119.0, 596.0, 290.0, 44.0)
         596.0
         618.0
         640.0
         20.0
         
         6.5inch
         (119.0, 552.0, 290.0, 44.0)
         552.0
         574.0
         596.0
         (119.0, 596.0, 290.0, 44.0)
         596.0
         618.0
         640.0
         47.0

         */
        switch updateIndex {
            case 0:
                posY = uiLabels_frames[0].midY - safeAreaTop
                
            case 1:
                posY = uiLabels_frames[1].midY - safeAreaTop
                
            default:
                dismiss(animated: true, completion: nil)
                return
        }
        
        spotlightView.appear(Spotlight.RoundedRect(center: CGPoint(x: uiLabels_frames[0].midX, y: posY),
                                                   size: CGSize(width: width, height: height),
                                                   cornerRadius: 50))
        
        updateIndex += 1
    }
}


// MARK: - SpotlightViewControllerDelegate
extension MenuTutorialSpotlightViewController: SpotlightViewControllerDelegate {
    
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
