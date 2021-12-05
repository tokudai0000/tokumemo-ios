//
//  SettingsViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit
import FirebaseAnalytics

final class SettingsViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    private let model = Model()
//    private let webViewModel = WebViewModel()
    private let viewModel = SettingViewModel()
    
    public var delegate : MainViewController?
    private let dataManager = DataManager.singleton
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初回起動時処理
        viewModel.firstBootDecision()
        
        self.tableView.reloadData()
    }
    
}


// MARK: - TableView
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource{
    
    /// セクションの高さ
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 1
    }
    
    /// セクション数
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataManager.allCellList.count
    }
    
    // セクションの背景とテキストの色を変更する
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section == 1 {
            view.tintColor = .gray
        }
    }
    
    /// セクション内のセル数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.allCellList[section].count
    }
    
    /// cellの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.tableCell, for: indexPath)!
        tableCell.textLabel!.text = dataManager.allCellList[indexPath.section][indexPath.item].title
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
        
        dismiss(animated: false, completion: nil)
        if let delegate = delegate {
            switch dataManager.allCellList[indexPath[0]][indexPath[1]].type {
//            case .libraryCalendar:                   // [図書館]開館カレンダー
//                if let url = webViewModel.getLibraryCalenderUrl() {
//                    delegate.webView.load(url)
//                }
                
            case .syllabus:                          // シラバス
                delegate.showModalView(scene: .syllabus)
                
            case .password:                          // パスワード設定
                delegate.showModalView(scene: .password)
                
            case .aboutThisApp:                      // このアプリについて
                delegate.showModalView(scene: .aboutThisApp)
                
            default:
                if let url = URL(string: dataManager.allCellList[indexPath[0]][indexPath[1]].url) {
                    delegate.webView.load(URLRequest(url: url))
                    
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
                dismiss(animated: false, completion: nil)
            }
        }
    }
}
