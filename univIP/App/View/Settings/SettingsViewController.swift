//
//  SettingsViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit
import Kanna

class SettingsViewController: BaseViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var editButton: UIButton!
    
    private let model = Model()
//    private let urlModel = UrlModel()
    private let viewModel = SettingViewModel()
    public var urlModel: UrlModel!
    
    var delegateMain : MainViewController?
    var delegatePass : PasswordSettingsViewController?
    var userDefaults = UserDefaults.standard
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        firstBootDecision()
        setup()

        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        viewAnimated(scene: "settingsViewAppear")
    }
    
    @IBAction func editAction(_ sender: Any) {
        tableView.isEditing = viewModel.editSituation
        if viewModel.editSituation {
            editButton.titleLabel?.text = "編集"
        }else{
            editButton.titleLabel?.text = "終了"
        }
        viewModel.editSituation = !viewModel.editSituation
        self.tableView.reloadData()
    }
    
    
    //MARK:- Private func
    private func setup() {
        tableView.separatorColor = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 0.5)
        viewModel.allCellList[0] = viewModel.loadCellList()
    }
    
    
    // 初回起動時判定
    private func firstBootDecision() {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let versionKey = "ver_" + version
        // 保存されたデータがversionいつの物か判定
        print(UserDefaults.standard.string(forKey: "VersionKey"))
        if UserDefaults.standard.string(forKey: "VersionKey") != versionKey{
            UserDefaults.standard.set(versionKey, forKey: "VersionKey") // 更新
            
            let legacyCellLists = viewModel.loadCellList()
            var newCellLists = model.cellList
            
            for i in 0 ..< newCellLists.count{
                if legacyCellLists.count <= i{
                    viewModel.cellList.append(newCellLists[i])
                }else{
                    newCellLists[legacyCellLists[i].id].display = legacyCellLists[i].display
                    viewModel.cellList.append(newCellLists[legacyCellLists[i].id])
                }
            }
            print(viewModel.cellList)
            viewModel.saveCellList(lists: viewModel.cellList)
        }
    }

    
    private func viewAnimated(scene:String){
        switch scene {
        case "settingsViewAppear":
            // メニューの位置を取得する
            let menuPos = self.contentView.layer.position
            // 初期位置を画面の外側にするため、メニューの幅の分だけマイナスする
            self.contentView.layer.position.x = -self.contentView.frame.width
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                options: .curveEaseOut,
                animations: {
                    self.contentView.layer.position.x = menuPos.x
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
                }
            )
        default:
            return
        }
    }
    
    //MARK:- Override(Animate)

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
        return viewModel.allCellList.count
    }
    
    
    /// セクション内のセル数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.allCellList[section].count
    }
    
    
    /// cellの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let TableCell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)

        TableCell.textLabel!.text = viewModel.allCellList[indexPath.section][indexPath.item].name
        TableCell.detailTextLabel?.text = viewModel.allCellList[indexPath.section][indexPath.item].category
        TableCell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator // 「>」ボタンを設定
        TableCell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        TableCell.detailTextLabel?.font = UIFont.systemFont(ofSize: 11)
        
        return TableCell
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
        let todo = viewModel.allCellList[sourceIndexPath.section][sourceIndexPath.row]
        viewModel.allCellList[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        viewModel.allCellList[sourceIndexPath.section].insert(todo, at: destinationIndexPath.row)
        viewModel.saveCellList(lists: viewModel.allCellList[0])
    }
    
    
    /// 「編集モード」追加、削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            viewModel.allCellList[indexPath.section][indexPath.row].display = false
        }else{
            viewModel.allCellList[indexPath.section][indexPath.row].display = true
        }
        
        viewModel.saveCellList(lists: viewModel.allCellList[0])
        self.tableView.reloadData()
    }
    
    
    /// セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !viewModel.editSituation {
            return CGFloat(viewModel.cellHight)
        }else{
            if !viewModel.allCellList[indexPath.section][indexPath.row].display {
                return 0
            }else{
                return CGFloat(viewModel.cellHight)
            }
        }
    }
    
    // セクションの背景とテキストの色を決定するメソッド
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 0.6)
    }


    /// 編集スタイル
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        if tableView.isEditing{
            if viewModel.allCellList[indexPath.section][indexPath.row].display {
                return .delete
            }else{
                return .insert
            }
        }
        return .none
    }

    
    // セルを選択した時のイベント
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.dismiss(animated: false, completion: nil)
        
        guard let delegate = delegateMain else {
            return
        }
        
        let cellId = viewModel.allCellList[indexPath[0]][indexPath[1]].id
        
        switch cellId {
        case 0: // Webサイト
            let response = urlModel.url(.libraryLogin)
            if let url = response.1 as URLRequest? {
                delegate.webView.load(url)
            } else {
                delegate.toast(message: "ERROR")
            }
            
            
        case 1: // 貸し出し期間延長
            let response = urlModel.url(.libraryBookLendingExtension)
            if let url = response.1 as URLRequest? {
                delegate.webView.load(url)
            } else {
                delegate.toast(message: "登録者のみ")
            }
            delegate.navigationRightButtonOnOff(operation: "DOWN")
            
            
        case 2: // 本購入リクエスト
            let response = urlModel.url(.libraryBookPurchaseRequest)
            if let url = response.1 as URLRequest? {
                delegate.webView.load(url)
            } else {
                delegate.toast(message: "登録者のみ")
            }
            delegate.navigationRightButtonOnOff(operation: "DOWN")
            
            
        case 3: // 開館カレンダー
            let response = urlModel.url(.libraryCalendar)
            if let url = response.1 as URLRequest? {
                delegate.webView.load(url)
            } else {
                delegate.toast(message: "失敗しました")
            }
            delegate.navigationRightButtonOnOff(operation: "DOWN")

            
        case 4: // シラバス
            delegate.popupView(scene: .syllabus)

            
        case 5: // 時間割
            let response = urlModel.url(.timeTable)
            if let url = response.1 as URLRequest? {
                delegate.webView.load(url)
            } else {
                delegate.toast(message: "登録者のみ")
            }
            delegate.navigationRightButtonOnOff(operation: "UP")
            
            
        case 6: // 今年の成績表
            let response = urlModel.url(.currentTermPerformance)
            if let url = response.1 as URLRequest? {
                delegate.webView.load(url)
            } else {
                delegate.toast(message: "登録者のみ")
            }
            
            
        case 7: // 成績参照
            let response = urlModel.url(.termPerformance)
            if let url = response.1 as URLRequest? {
                delegate.webView.load(url)
            } else {
                delegate.toast(message: "登録者のみ")
            }
            delegate.navigationRightButtonOnOff(operation: "UP")
            
            
        case 8: // 出欠記録
            let response = urlModel.url(.presenceAbsenceRecord)
            if let url = response.1 as URLRequest? {
                delegate.webView.load(url)
            } else {
                delegate.toast(message: "登録者のみ")
            }
            delegate.navigationRightButtonOnOff(operation: "UP")
            
            
        case 9: // 授業アンケート
            let response = urlModel.url(.classQuestionnaire)
            if let url = response.1 as URLRequest? {
                delegate.webView.load(url)
            } else {
                delegate.toast(message: "登録者のみ")
            }
            delegate.navigationRightButtonOnOff(operation: "UP")
            
            
        case 10: // メール
            let response = urlModel.url(.mailService)
            if let url = response.1 as URLRequest? {
                delegate.webView.load(url)
            } else {
                delegate.toast(message: "登録者のみ")
            }
            delegate.navigationRightButtonOnOff(operation: "DOWN")
            
            
        case 11: // マナバPC版
            let response = urlModel.url(.manabaPC)
            if let url = response.1 as URLRequest? {
                delegate.webView.load(url)
            } else {
                delegate.toast(message: "登録者のみ")
            }
            delegate.navigationRightButtonOnOff(operation: "DOWN")
            
            
        case 12: // キャリア支援室
            let response = urlModel.url(.tokudaiCareerCenter)
            if let url = response.1 as URLRequest? {
                delegate.webView.load(url)
            } else {
                delegate.toast(message: "失敗しました")
            }
            delegate.navigationRightButtonOnOff(operation: "DOWN")
            
            
        case 13: // 履修登録
            let response = urlModel.url(.courseRegistration)
            if let url = response.1 as URLRequest? {
                delegate.webView.load(url)
            } else {
                delegate.toast(message: "登録者のみ")
            }
            delegate.navigationRightButtonOnOff(operation: "UP")
            
            
        case 100: // パスワード設定
            delegate.popupView(scene: .password)
            
            
        case 101: // このアプリについて
            delegate.popupView(scene: .aboutThisApp)

            
        case 102: // 開発者へ連絡
            delegate.popupView(scene: .contactToDeveloper)
            
            
        default:
            return
        }
    }
    
    /// 編集できるセクションを限定
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 { return false }
        return true
    }
    
}
