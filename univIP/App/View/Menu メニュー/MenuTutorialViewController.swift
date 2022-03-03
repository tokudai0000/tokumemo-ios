//
//  TutorialSpotlightMenuViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/12/23.
//

import Gecco

final class MenuTutorialViewController: SpotlightViewController {
    
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
                label.text = "トクメモをさらに使いやすくするために、設定を行いましょう"
            case 1:
                label.text = "パスワードを入力し、自動ログイン機能を活用しましよう"
            case 2:
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
        
        // MARK: - HACK なぜ見た目正常に動いているかわからない
        let safeAreaTop = 47 - self.view.safeAreaInsets.top
        
        switch updateIndex {
            case 0:
                posY = uiLabels_frames[0].midY - safeAreaTop
                
            case 1:
                posY = uiLabels_frames[1].midY - safeAreaTop
                
            case 2:
                posY = uiLabels_frames[2].midY - safeAreaTop
                
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
extension MenuTutorialViewController: SpotlightViewControllerDelegate {
    
    //画面が表示される時
    func spotlightViewControllerWillPresent(_ viewController: SpotlightViewController, animated: Bool) {
        createLabels()
        createSpotlight()
    }
    //画面タップ時
    func spotlightViewControllerTapped(_ viewController: SpotlightViewController, tappedSpotlight: SpotlightType?) {
        // メニューリストを設定用リストへ更新する
        delegateMenu?.viewModel.menuLists = Constant.initSettingLists
        delegateMenu?.tableView.reloadData()
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
