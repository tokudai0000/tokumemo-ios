//
//  SettingsViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit
import Kanna
import FirebaseAnalytics

final class SettingsViewController: BaseViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var editButton: UIButton!
    
    private let model = Model()
    private let webViewModel = WebViewModel()
    private let viewModel = SettingViewModel()
    
    public var delegate : MainViewController!
    
    private let dataManager = DataManager.singleton
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        viewAnimated(scene: .settingViewAppear)
    }
    
    
    // MARK: - IBAction
    @IBAction func editButton(_ sender: Any) {
        tableView.allowsMultipleSelectionDuringEditing = viewModel.editSituation // 編集モード時、複数選択を許可
        tableView.setEditing(viewModel.editSituation, animated: true)            // 編集モード起動、停止
        viewModel.editSituation = !viewModel.editSituation                       // 編集モード, 使用モード反転
        self.tableView.reloadData()
        
        if viewModel.editSituation {
            Analytics.logEvent("settingViewEditButton", parameters: nil) // Analytics: 調べる・タップ
            editButton.setTitle("編集", for: .normal)
            editButton.setTitle("完了", for: .normal)
        } else {
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
    private func setup() {
        // 初回起動時処理
        viewModel.firstBootDecision()
        // セル同士の仕切り板
        tableView.separatorColor = UIColor(white: 0, alpha: 0)
        self.tableView.reloadData()
    }
    
    
    enum ViewAnimationType {
        case settingViewAppear
        case settingsViewDisappear
    }
    
    private func viewAnimated(scene: ViewAnimationType) {
        switch scene {
        case .settingViewAppear:
            //制約を追加　width:self.view.frame.width/2
            let widthConstraint = NSLayoutConstraint.init(item: self.contentView!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.view.frame.width * (3 / 4) )
            widthConstraint.isActive = true
            // メニューの位置を取得する
            let menuPos = self.view.frame.width * (3 / 4)
            // 初期位置を画面の外側にするため、メニューの幅の分だけマイナスする
            self.contentView.layer.position.x = -self.view.frame.width * (3 / 4)
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                options: .curveEaseOut,
                animations: {
                    self.contentView.layer.position.x = menuPos
                },
                completion: { bool in
                })
            
            
        case .settingsViewDisappear:
            UIView.animate(
                withDuration: 0.2,
                delay: 0,
                options: .curveEaseIn,
                animations: {
                    self.contentView.layer.position.x = -self.contentView.frame.width
                },
                completion: { _ in
                    self.dismiss(animated: false, completion: nil)
                })
        }
    }
    
    private func tableViewEvent(url: WebViewModel.SelectUrlList, word: String = "ERROR", viewOperation: MainViewModel.ViewOperation) {
        let response = webViewModel.url(url)
        if let url = response as URLRequest? {
            delegate.wkWebView.load(url)
        } else {
            delegate.toast(message: word)
        }
        delegate.navigationRightButtonOnOff(operation: viewOperation)
    }
    
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
        let tableCell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
        // MARK: - Question 「!」でいいのか
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
        // 編集モードでの選択時処理無効
        if !viewModel.editSituation {
            // チェックボックスTrueの場合
            if indexPath.section == 0 {
                dataManager.allCellList[indexPath.section][indexPath.row].isDisplay = true
            }
            viewModel.saveCellList(lists: dataManager.allCellList[0])
            return
        }
        
        Analytics.logEvent("\(dataManager.allCellList[indexPath[0]][indexPath[1]].type)", parameters: nil) // Analytics: 調べる・タップ
        
        // MARK: - Question シラバスに不具合
        // viewAnimated(scene: "settingsViewDisappear")**修正必須**
        self.dismiss(animated: false, completion: nil)
        
        guard let delegate = delegate else {
            return
        }
        
        let cellType = dataManager.allCellList[indexPath[0]][indexPath[1]].type
        
        switch cellType {
        case .libraryWeb: // 図書館Webサイト
            tableViewEvent(url: .libraryHome,
                           viewOperation: .down)
            
        case .libraryMyPage: // 図書館MyPage
            tableViewEvent(url: .libraryLogin,
                           word: "登録者のみ",
                           viewOperation: .down)
            
        case .libraryBookLendingExtension: // 貸し出し期間延長
            tableViewEvent(url: .libraryBookLendingExtension,
                           word: "登録者のみ",
                           viewOperation: .down)
            
        case .libraryBookPurchaseRequest: // 本購入リクエスト
            tableViewEvent(url: .libraryBookPurchaseRequest,
                           word: "登録者のみ",
                           viewOperation: .down)
            
        case .libraryCalendar: // 開館カレンダー
            tableViewEvent(url: .libraryCalendar,
                           viewOperation: .down)
            
        case .syllabus: // シラバス
            delegate.popupView(scene: .syllabus)
            
        case .timeTable: // 時間割
            tableViewEvent(url: .timeTable,
                           word: "登録者のみ",
                           viewOperation: .up)
            
        case .currentTermPerformance: // 今年の成績表
            tableViewEvent(url: .currentTermPerformance,
                           word: "登録者のみ",
                           viewOperation: .up)
            
        case .termPerformance: // 成績参照
            tableViewEvent(url: .termPerformance,
                           word: "登録者のみ",
                           viewOperation: .up)
            
        case .presenceAbsenceRecord: // 出欠記録
            tableViewEvent(url: .presenceAbsenceRecord,
                           word: "登録者のみ",
                           viewOperation: .up)
            
        case .classQuestionnaire: // 授業アンケート
            tableViewEvent(url: .classQuestionnaire,
                           word: "登録者のみ",
                           viewOperation: .up)
            
        case .mailService: // メール
            tableViewEvent(url: .mailService,
                           word: "登録者のみ",
                           viewOperation: .down)
            
        case .tokudaiCareerCenter: // キャリア支援室
            tableViewEvent(url: .tokudaiCareerCenter,
                           viewOperation: .down)
            
        case .courseRegistration: // 履修登録
            tableViewEvent(url: .courseRegistration,
                           word: "登録者のみ",
                           viewOperation: .up)
            
        case .systemServiceList: // システムサービス一覧
            tableViewEvent(url: .systemServiceList,
                           viewOperation: .up)
            
        case .eLearningList: // Eラーニング一覧
            tableViewEvent(url: .eLearningList,
                           viewOperation: .up)
            
        case .universityWeb: // 大学サイト
            tableViewEvent(url: .universityHome,
                           viewOperation: .up)
            
        case .password: // パスワード設定
            delegate.popupView(scene: .password)
            
        case .aboutThisApp: // このアプリについて
            delegate.popupView(scene: .aboutThisApp)
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
