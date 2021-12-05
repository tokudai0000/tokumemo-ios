//
//  SettingsViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit
import FirebaseAnalytics

final class SettingsViewController: BaseViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var editButton: UIButton!
    
    private let model = Model()
    private let webViewModel = WebViewModel()
    private let viewModel = SettingViewModel()
    
    public var delegate : MainViewController?
    
    private let dataManager = DataManager.singleton
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初回起動時処理
        viewModel.firstBootDecision()
        // セル同士の仕切り板(透明)
        tableView.separatorColor = UIColor(white: 0, alpha: 0)
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        viewAnimated(scene: .settingViewAppear)
    }
    
    
    // MARK: - IBAction
    @IBAction func editButton(_ sender: Any) {
        // 編集モード時、複数選択を許可
        tableView.allowsMultipleSelectionDuringEditing = viewModel.editSituation
        // 編集モード起動、停止
        tableView.setEditing(viewModel.editSituation, animated: true)
        // 編集モード, 使用モード反転
        viewModel.editSituation = !viewModel.editSituation
        
        self.tableView.reloadData()
        
        if viewModel.editSituation {
            editButton.setTitle("編集", for: .normal)
        } else {
            Analytics.logEvent("settingViewEditButton", parameters: nil)
            
            editButton.setTitle("完了", for: .normal)
        }
        
        // 編集モード時、display=true のセルを選択状態にする
        if !viewModel.editSituation {
            for i in 0 ..< dataManager.allCellList[0].count {
                if dataManager.allCellList[0][i].isDisplay {
                    self.tableView.selectRow(at: [0,i], animated: true, scrollPosition: .bottom)
                }
            }
        }
        
    }
    
    
    // MARK: - Private func
    enum ViewAnimationType {
        case settingViewAppear
        case settingsViewDisappear
    }
    
    private func viewAnimated(scene: ViewAnimationType) {
        switch scene {
        case .settingViewAppear:
            // Viewは1/4残した状態で左からスライドして表示
            let menuPos = self.view.frame.width * (3 / 4)
            
            //制約を追加　width:self.view.frame.width/2
            let widthConstraint = NSLayoutConstraint.init(item: self.contentView!,
                                                          attribute: .width,
                                                          relatedBy: .equal,
                                                          toItem: nil,
                                                          attribute: .notAnAttribute,
                                                          multiplier: 1.0,
                                                          constant: self.view.frame.width * (3 / 4))
            // 制約有効化
            widthConstraint.isActive = true
            
            // 初期位置を画面の外側にするため、メニューの幅の分だけマイナスする
            self.contentView.layer.position.x = -self.view.frame.width * (3 / 4)
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           options: .curveEaseOut,
                           animations: { self.contentView.layer.position.x = menuPos },
                           completion: { bool in }
            )
            
            
        case .settingsViewDisappear:
            UIView.animate(withDuration: 0.2,
                           delay: 0,
                           options: .curveEaseIn,
                           animations: { self.contentView.layer.position.x = -self.contentView.frame.width },
                           completion: { _ in self.dismiss(animated: false, completion: nil) }
            )
        }
    }
    
//    private func tableViewEvent(url: WebViewModel.SelectUrlList, word: String = "ERROR", viewOperation: MainViewModel.ViewMoveType) {
//        guard let delegate = delegate else {
//            return
//        }
//        let response = webViewModel.url(url)
//        if let url = response as URLRequest? {
//            delegate.wkWebView.load(url)
//        } else {
//            delegate.toast(message: word)
//        }
//        delegate.viewVerticallyMove(operation: viewOperation)
//    }
    
}


// MARK: - TableView
extension SettingsViewController:  UITableViewDelegate, UITableViewDataSource{
    
    /// セクションの高さ
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(viewModel.sectionHight)
    }
    
    /// セクション数
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataManager.allCellList.count
    }
    
    /// セクションのタイトル
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        return model.sectionLists[section]
    }
    
    /// セクション内のセル数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.allCellList[section].count
    }
    
    /// cellの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) // R.swift
        tableCell.textLabel!.text = dataManager.allCellList[indexPath.section][indexPath.item].title
        tableCell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator // 「>」ボタンを設定
        tableCell.textLabel!.font = UIFont.systemFont(ofSize: 17)
        return tableCell
    }
    
    /// 並び替え
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if sourceIndexPath.section == proposedDestinationIndexPath.section {
            return proposedDestinationIndexPath
        }
        return sourceIndexPath
    }
    
    /// 「編集モード」並び替え検知
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let todo = dataManager.allCellList[sourceIndexPath.section][sourceIndexPath.row]
        dataManager.allCellList[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        dataManager.allCellList[sourceIndexPath.section].insert(todo, at: destinationIndexPath.row)
        viewModel.saveCellList(lists: dataManager.allCellList[0])
    }
    
    /// セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.editSituation {
            if dataManager.allCellList[indexPath.section][indexPath.row].isDisplay {
                return CGFloat(viewModel.cellHight)
            } else {
                return 0
            }
        } else {
            return CGFloat(viewModel.cellHight)
        }
    }
    
    /// セルを選択した時のイベント
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 編集モード判定
        if !viewModel.editSituation {
            if indexPath.section == 0 {
                // チェックボックスTrueの際、ここを通る。Falseの時didDeselectRowAtを通る
                dataManager.allCellList[indexPath.section][indexPath.row].isDisplay = true
            }
            viewModel.saveCellList(lists: dataManager.allCellList[0])
            return
        }
        
        Analytics.logEvent("\(dataManager.allCellList[indexPath[0]][indexPath[1]].type)", parameters: nil)
        
        if let delegate = delegate {
            switch dataManager.allCellList[indexPath[0]][indexPath[1]].type {
            case .libraryCalendar:                   // [図書館]開館カレンダー
                dismiss(animated: false, completion: nil)
                if let url = webViewModel.getLibraryCalenderUrl() {
                    delegate.wkWebView.load(url)
                }
                
            case .syllabus:                          // シラバス
                dismiss(animated: false, completion: nil)
                delegate.showModalView(scene: .syllabus)
                
            case .password:                          // パスワード設定
                dismiss(animated: false, completion: nil)
                delegate.showModalView(scene: .password)
                
            case .aboutThisApp:                      // このアプリについて
                dismiss(animated: false, completion: nil)
                delegate.showModalView(scene: .aboutThisApp)
                
            default:
                viewAnimated(scene: .settingsViewDisappear)
                if let url = URL(string: dataManager.allCellList[indexPath[0]][indexPath[1]].url) {
                    delegate.wkWebView.load(URLRequest(url: url))
                    
                } else {
                    // エラー処理
                    AKLog(level: .FATAL, message: "URLフォーマットエラー")
                    fatalError() // 予期しないため、強制的にアプリを落とす
                }
            }
        }
        
    }
    
    /// 編集モード時、チェックが外された時
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // サービス一覧のみ編集可能
        if indexPath.section == 0 {
            dataManager.allCellList[indexPath.section][indexPath.row].isDisplay = false
            viewModel.saveCellList(lists: dataManager.allCellList[0])
        }
    }
    
    /// 編集できるセクションを限定
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return true
        }
        return false
    }
    
}


// MARK: - Override(Animate)
extension SettingsViewController {
    
    // メニューエリア以外タップ時、画面をMainViewに戻る
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            if touch.view?.tag == 1 {
                viewAnimated(scene: .settingsViewDisappear)
            }
        }
    }
}
