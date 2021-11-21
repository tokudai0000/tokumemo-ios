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
    private let viewModel = SettingViewModel()
    
    private let dataManager = DataManager.singleton
    private let webViewModel = WebViewModel()
    
    public var delegate : MainViewController?
    private var delegatePass : PasswordSettingsViewController?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        viewAnimated(scene: "settingsViewAppear")
    }
    
    
    // MARK: - IBAction
    @IBAction func editButton(_ sender: Any) {
        
        if viewModel.editSituation {
            editButton.setTitle("完了", for: .normal)
            
        }else{
            Analytics.logEvent("settingViewEditButton", parameters: nil) // Analytics: 調べる・タップ
            editButton.setTitle("編集", for: .normal)
            
        }
        
        tableView.allowsMultipleSelectionDuringEditing = viewModel.editSituation // 編集モード時、複数選択を許可
        tableView.setEditing(viewModel.editSituation, animated: true)            // 編集モード起動、停止
        viewModel.editSituation = !viewModel.editSituation                       // 編集モード, 使用モード反転
        
        self.tableView.reloadData()
        
        if !viewModel.editSituation {
            for i in 0 ..< dataManager.allCellList[0].count {
                print(dataManager.allCellList[0][i].isDisplay)
                if dataManager.allCellList[0][i].isDisplay {
                    self.tableView.selectRow(at: [0,i], animated: true, scrollPosition: .bottom)
                }
            }
            
        }
    }
    
    
    // MARK: - Private func
    private func setup() {
        
        viewModel.firstBootDecision() // 初回起動時処理
        tableView.separatorColor = UIColor(white: 0, alpha: 0)
        self.tableView.reloadData()
    }
    
    
    private func viewAnimated(scene:String){
        switch scene {
        case "settingsViewAppear":
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
            
            
        case "settingsViewDisappear":
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
            
            
        default:
            return
        }
    }
    
    // MARK: - Override(Animate)
    
    // メニューエリア以外タップ時の処理
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            if touch.view?.tag == 1 {
                viewAnimated(scene: "settingsViewDisappear")
            }
        }
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
    
    // セクションのタイトル
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
        
        tableCell.textLabel!.text = dataManager.allCellList[indexPath.section][indexPath.item].title
        // セルの詳細情報
        //        tableCell.detailTextLabel?.text = dataManager.allCellList[indexPath.section][indexPath.item].category
        //        tableCell.detailTextLabel?.font = UIFont.systemFont(ofSize: 11)
        tableCell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator // 「>」ボタンを設定
        tableCell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        
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
        if !viewModel.editSituation {
            return CGFloat(viewModel.cellHight)
        }else{
            if !dataManager.allCellList[indexPath.section][indexPath.row].isDisplay {
                return 0
            }else{
                return CGFloat(viewModel.cellHight)
            }
        }
    }
    
    
    // セルを選択した時のイベント
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

        // シラバスに不具合
        //        viewAnimated(scene: "settingsViewDisappear")**修正必須**
        self.dismiss(animated: false, completion: nil)
        
        guard let delegate = delegate else {
            return
        }
        
        let cellType = dataManager.allCellList[indexPath[0]][indexPath[1]].type
        
        switch cellType {
        case .libraryWeb: // 図書館Webサイト
            let response = webViewModel.url(.libraryHome)
            if let url = response as URLRequest? {
                delegate.wkWebView.load(url)
            } else {
                delegate.toast(message: "ERROR")
            }
            delegate.navigationRightButtonOnOff(operation: .down)
            
        case .libraryMyPage: // 図書館MyPage
            let response = webViewModel.url(.libraryLogin)
            if let url = response as URLRequest? {
                delegate.wkWebView.load(url)
            } else {
                delegate.toast(message: "登録者のみ")
            }
            delegate.navigationRightButtonOnOff(operation: .down)
            
        case .libraryBookLendingExtension: // 貸し出し期間延長
            let response = webViewModel.url(.libraryBookLendingExtension)
            if let url = response as URLRequest? {
                delegate.wkWebView.load(url)
            } else {
                delegate.toast(message: "登録者のみ")
            }
            delegate.navigationRightButtonOnOff(operation: .down)
            
            
        case .libraryBookPurchaseRequest: // 本購入リクエスト
            let response = webViewModel.url(.libraryBookPurchaseRequest)
            if let url = response as URLRequest? {
                delegate.wkWebView.load(url)
            } else {
                delegate.toast(message: "登録者のみ")
            }
            delegate.navigationRightButtonOnOff(operation: .down)
            
            
        case .libraryCalendar: // 開館カレンダー
            let response = webViewModel.url(.libraryCalendar)
            if let url = response as URLRequest? {
                delegate.wkWebView.load(url)
            } else {
                delegate.toast(message: "失敗しました")
            }
            delegate.navigationRightButtonOnOff(operation: .down)
            
            
        case .syllabus: // シラバス
            delegate.popupView(scene: .syllabus)
            
            
        case .timeTable: // 時間割
            let response = webViewModel.url(.timeTable)
            if let url = response as URLRequest? {
                delegate.wkWebView.load(url)
            } else {
                delegate.toast(message: "登録者のみ")
            }
            delegate.navigationRightButtonOnOff(operation: .up)
            
            
        case .currentTermPerformance: // 今年の成績表
            let response = webViewModel.url(.currentTermPerformance)
            if let url = response as URLRequest? {
                delegate.wkWebView.load(url)
            } else {
                delegate.toast(message: "登録者のみ")
            }
            
            
        case .termPerformance: // 成績参照
            let response = webViewModel.url(.termPerformance)
            if let url = response as URLRequest? {
                delegate.wkWebView.load(url)
            } else {
                delegate.toast(message: "登録者のみ")
            }
            delegate.navigationRightButtonOnOff(operation: .up)
            
            
        case .presenceAbsenceRecord: // 出欠記録
            let response = webViewModel.url(.presenceAbsenceRecord)
            if let url = response as URLRequest? {
                delegate.wkWebView.load(url)
            } else {
                delegate.toast(message: "登録者のみ")
            }
            delegate.navigationRightButtonOnOff(operation: .up)
            
            
        case .classQuestionnaire: // 授業アンケート
            let response = webViewModel.url(.classQuestionnaire)
            if let url = response as URLRequest? {
                delegate.wkWebView.load(url)
            } else {
                delegate.toast(message: "登録者のみ")
            }
            delegate.navigationRightButtonOnOff(operation: .up)
            
            
        case .mailService: // メール
            let response = webViewModel.url(.mailService)
            if let url = response as URLRequest? {
                delegate.wkWebView.load(url)
            } else {
                delegate.toast(message: "登録者のみ")
            }
            delegate.navigationRightButtonOnOff(operation: .down)
            
            
        case .tokudaiCareerCenter: // キャリア支援室
            let response = webViewModel.url(.tokudaiCareerCenter)
            if let url = response as URLRequest? {
                delegate.wkWebView.load(url)
            } else {
                delegate.toast(message: "失敗しました")
            }
            delegate.navigationRightButtonOnOff(operation: .down)
            
            
        case .courseRegistration: // 履修登録
            let response = webViewModel.url(.courseRegistration)
            if let url = response as URLRequest? {
                delegate.wkWebView.load(url)
            } else {
                delegate.toast(message: "登録者のみ")
            }
            delegate.navigationRightButtonOnOff(operation: .up)
            
            
        case .systemServiceList: // システムサービス一覧
            let response = webViewModel.url(.systemServiceList)
            if let url = response as URLRequest? {
                delegate.wkWebView.load(url)
            } else {
                delegate.toast(message: "登録者のみ")
            }
            delegate.navigationRightButtonOnOff(operation: .up)
            
            
        case .eLearningList: // Eラーニング一覧
            let response = webViewModel.url(.eLearningList)
            if let url = response as URLRequest? {
                delegate.wkWebView.load(url)
            } else {
                delegate.toast(message: "登録者のみ")
            }
            delegate.navigationRightButtonOnOff(operation: .up)
            
            
        case .universityWeb: // 大学サイト
            let response = webViewModel.url(.universityHome)
            if let url = response as URLRequest? {
                delegate.wkWebView.load(url)
            } else {
                delegate.toast(message: "登録者のみ")
            }
            delegate.navigationRightButtonOnOff(operation: .up)
            
            
        case .password: // パスワード設定
            delegate.popupView(scene: .password)
            
            
        case .aboutThisApp: // このアプリについて
            delegate.popupView(scene: .aboutThisApp)
            
        }
    }
    
    // 編集モード時、チェックが外された時
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            dataManager.allCellList[indexPath.section][indexPath.row].isDisplay = false
            
        }
        viewModel.saveCellList(lists: dataManager.allCellList[0])
    }
    
    /// 編集できるセクションを限定
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 { return false }
        return true
    }
    
}
