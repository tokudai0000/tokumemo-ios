//
//  TutorialSpotlightViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/12/23.
//

import Gecco

class TutorialViewController: SpotlightViewController, SpotlightViewControllerDelegate{

    // 各UILabelの座標データ
    public var uiLabels_frames:[CGRect] = []
    // 各TextLabelの文字列
    public var textLabels:[String] = []
    
    public var updateIndex = 0
    
    private let label = UILabel()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    public func createLabels(_ frame: CGRect) {
        label.text = textLabels[updateIndex]
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize:15)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.frame = frame
        self.view.addSubview(label)
    }
    
    public func createSpotlight(_ center: CGPoint, _ size: CGSize) {
        spotlightView.appear(Spotlight.RoundedRect(center: center,
                                                   size: size,
                                                   cornerRadius: 50))
    }
    
    func spotlightViewControllerWillPresent(_ viewController: SpotlightViewController, animated: Bool) {}
    func spotlightViewControllerWillDismiss(_ viewController: SpotlightViewController, animated: Bool) {}
    func spotlightViewControllerTapped(_ viewController: SpotlightViewController, tappedSpotlight: SpotlightType?) {}
}


// MARK: - MainTutorialViewController
final class MainTutorialViewController: TutorialViewController {

    public var mainViewController: MainViewController?
    
    private func showTutorial() {
        let label = CGRect(x: uiLabels_frames[updateIndex].minX - CGFloat(230),
                                y: uiLabels_frames[updateIndex].minY - CGFloat(70),
                                width: CGFloat(230),
                                height: CGFloat(70))
        createLabels(label)
        
        let center = CGPoint(x: uiLabels_frames[updateIndex].midX,
                             y: uiLabels_frames[updateIndex].midY)
        let size = CGSize(width: CGFloat(75),
                          height: CGFloat(70))
        createSpotlight(center, size)
    }
    
    //画面が表示される時
    override func spotlightViewControllerWillPresent(_ viewController: SpotlightViewController, animated: Bool) {
        showTutorial()
    }
    //画面タップ時
    override func spotlightViewControllerTapped(_ viewController: SpotlightViewController, tappedSpotlight: SpotlightType?) {
        updateIndex += 1
        if updateIndex == 2 {
            dismiss(animated: true, completion: nil)
            return
        }
        // 2個目のチュートリアル表示
        showTutorial()
    }
    
    //画面が消える時
    override func spotlightViewControllerWillDismiss(_ viewController: SpotlightViewController, animated: Bool) {
        self.dismiss(animated: true, completion: {
            // メインスレッドで実行 UIの処理など
            let vc = R.storyboard.menu.menuViewController()!
            self.mainViewController?.present(vc, animated: true, completion: nil)
        })
    }
}

// MARK: - MenuTutorialViewController
final class MenuTutorialViewController: TutorialViewController {
    
    public var menuViewController: MenuViewController?
    
    private func showTutorial() {

        let label = CGRect(x: uiLabels_frames[updateIndex].minX,
                           y: uiLabels_frames[updateIndex].minY - CGFloat(100),
                           width: CGFloat(280),
                           height: CGFloat(80))
        createLabels(label)
        
        let safeAreaTop = 47 - self.view.safeAreaInsets.top
        let center = CGPoint(x: uiLabels_frames[updateIndex].midX,
                             y: uiLabels_frames[updateIndex].midY - safeAreaTop)
        let size = CGSize(width: uiLabels_frames[updateIndex].width,
                          height: uiLabels_frames[updateIndex].height)
        createSpotlight(center, size)
    }
    
    //画面が表示される時
    override func spotlightViewControllerWillPresent(_ viewController: SpotlightViewController, animated: Bool) {
        showTutorial()
    }
    //画面タップ時
    override func spotlightViewControllerTapped(_ viewController: SpotlightViewController, tappedSpotlight: SpotlightType?) {
        updateIndex += 1
        if updateIndex == 1 {
            // メニューリストを設定用リストへ更新する
            menuViewController?.viewModel.menuLists = Constant.initSettingLists
            menuViewController?.tableView.reloadData()
            
        } else if updateIndex == 3 {
            dismiss(animated: true, completion: nil)
            return
        }
        // 2,3個目のチュートリアル表示
        showTutorial()
    }
    
    //画面が消える時
    override func spotlightViewControllerWillDismiss(_ viewController: SpotlightViewController, animated: Bool) {
        // チュートリアル画面消去後、メニュー画面も消去
        self.menuViewController?.dismiss(animated: true, completion: nil)
    }
}
