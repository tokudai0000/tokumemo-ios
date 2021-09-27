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
    
    private var sectionHight:Int = 2
    private var cellHight:Int = 44
    private var allCellList:[[CellList]] =  [[],
                                             [CellList(name: "パスワード設定", category: "", display: true),
                                              CellList(name: "このアプリについて", category: "", display: true),
                                              CellList(name: "開発者へ連絡", category: "", display: true)]]
    private var cellList:[CellList] = []

    
    var delegateMain : MainViewController?
    var delegatePass : PasswordSettingsViewController?
    var userDefaults = UserDefaults.standard
    
    private var editSituation = true
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 0.5)
        
        firstBootDecision()
        allCellList[0] = loadCellList()!
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        viewAnimated(scene: "settingsViewAppear")
    }
    
    @IBAction func editAction(_ sender: Any) {
        tableView.isEditing = editSituation
        if editSituation {
            editButton.titleLabel?.text = "編集"
        }else{
            editButton.titleLabel?.text = "終了"
        }
        editSituation = !editSituation
        self.tableView.reloadData()
    }
    
    //MARK:- Private func
    // 初回起動時判定
    private func firstBootDecision() {
        // 初回か判定
        if UserDefaults.standard.object(forKey: "SettingCellList") == nil{
            cellList = model.cellList
            saveCellList(lists: cellList)
        }
        // 更新か判定
//        if 
        
    }
    private func saveCellList(lists:[CellList]){
        let jsonEncoder = JSONEncoder()
        guard let data = try? jsonEncoder.encode(lists) else {
            return
        }
        UserDefaults.standard.set(data, forKey: "SettingCellList")
    }
    
    func loadCellList() -> [CellList]? {
        let jsonDecoder = JSONDecoder()
        guard let data = UserDefaults.standard.data(forKey: "SettingCellList"),
              let bookmarks = try? jsonDecoder.decode([CellList].self, from: data) else {
            return nil
        }
            
        return bookmarks
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
    // テーブル内のセクション数を決めるメソッド
    func numberOfSections(in tableView: UITableView) -> Int {
        return allCellList.count // 2
    }
    
    /// セクションの高さを設定
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(sectionHight)
    }
    
    // （＊＊必須＊＊）セクション内のセル数を決めるメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCellList[Int(section)].count
    }
    
    // （＊＊必須＊＊）セルのインスタンスを生成するメソッド「表示するcellの中身を決める」
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let TableCell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)

        TableCell.textLabel!.text = allCellList[indexPath.section][Int(indexPath.item)].name
        TableCell.detailTextLabel?.text = allCellList[indexPath.section][Int(indexPath.item)].category
        TableCell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator // ここで「>」ボタンを設定

        TableCell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        TableCell.detailTextLabel?.font = UIFont.systemFont(ofSize: 11)
        
        return TableCell
    }
    
    ///
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if sourceIndexPath.section == proposedDestinationIndexPath.section {
            return proposedDestinationIndexPath
        }
        return sourceIndexPath
    }
    
    /// 「編集モード」並び替え検知
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let todo = allCellList[sourceIndexPath.section][sourceIndexPath.row]
        allCellList[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        allCellList[sourceIndexPath.section].insert(todo, at: destinationIndexPath.row)
        saveCellList(lists: allCellList[0])
    }
    
    /// 「編集モード」追加、削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            allCellList[indexPath.section][indexPath.row].display = false
        }else{
            allCellList[indexPath.section][indexPath.row].display = true
        }
        
        saveCellList(lists: allCellList[0])
        self.tableView.reloadData()
    }
    
    /// セルの高さを決めるメソッド
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !editSituation {
            return CGFloat(cellHight)
        }else{
            if !allCellList[indexPath.section][indexPath.row].display {
                return 0
            }else{
                return CGFloat(cellHight)
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
            if allCellList[indexPath.section][indexPath.row].display {
                return .delete
            }else{
                return .insert
            }
        }
        return .none
    }

    
    // セルを選択した時のイベントを追加
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: false, completion: nil)
        
        guard let delegate = delegateMain else {
            return
        }
        let cellName = allCellList[indexPath[0]][indexPath[1]].name
        switch cellName {
        case "Webサイト":
            delegate.openUrl(urlForRegistrant: model.libraryLoginURL, urlForNotRegistrant: model.libraryHomeURL, alertTrigger: false)
        case "貸し出し期間延長":
            delegate.openUrl(urlForRegistrant: model.libraryBookLendingExtensionURL, urlForNotRegistrant: nil, alertTrigger: true)
        case "本購入リクエスト":
            delegate.openUrl(urlForRegistrant: model.libraryBookPurchaseRequestURL, urlForNotRegistrant: nil, alertTrigger: true)
        case "開館カレンダー":
            let url = NSURL(string: model.libraryHomeURL)
            let data = NSData(contentsOf: url! as URL)
            
            var calenderURL = ""
            
            do {
                let doc = try HTML(html: data! as Data, encoding: String.Encoding.utf8)
                for node in doc.xpath("//a") {
                    guard let str = node["href"] else {
                        return
                    }
                    if str.contains("pub/pdf/calender/calender_main_"){
                        calenderURL = "https://www.lib.tokushima-u.ac.jp/" + node["href"]!
                    }
                }
                
            } catch {
               return
            }
            
            if calenderURL != ""{
                delegate.openUrl(urlForRegistrant: calenderURL, urlForNotRegistrant: calenderURL, alertTrigger: false)
            }else{
                toast(message: "失敗しました")
            }
            
            
            
//            let current = Calendar.current
//            var year = current.component(.year, from: Date())
//            let month = current.component(.month, from: Date())
//
//            if (month <= 3){ // 1月から3月までは前年のカレンダーにあるから
//                year -= 1
//            }
//            let libraryCalendarURL = model.libraryCalendar + String(year) + ".pdf"
//            delegate.openUrl(urlForRegistrant: libraryCalendarURL, urlForNotRegistrant: libraryCalendarURL, alertTrigger: false)
            
//            delegate.openUrl(urlForRegistrant: "https://www.lib.tokushima-u.ac.jp/pub/pdf/calender/calender_main_2021_8.pdf", urlForNotRegistrant: model.libraryHomeURL, alertTrigger: false)
        case "授業アンケート":
            delegate.openUrl(urlForRegistrant: model.classQuestionnaire, urlForNotRegistrant: nil, alertTrigger: true)
        case "シラバス":
            delegate.popupView(scene: "syllabus")
            
        case "時間割":
            delegate.openUrl(urlForRegistrant: model.timeTableURL, urlForNotRegistrant: nil, alertTrigger: true)
            
        case "今年の成績表":
            let current = Calendar.current
            var year = current.component(.year, from: Date())
            let month = current.component(.month, from: Date())
            
            if (month <= 3){ // 1月から3月までは前年の成績であるから
                year -= 1
            }
            let termPerformanceYearURL = model.currentTermPerformanceURL + String(year)
            delegate.openUrl(urlForRegistrant: termPerformanceYearURL, urlForNotRegistrant: nil, alertTrigger: true)
            
        case "成績参照":
            delegate.openUrl(urlForRegistrant: model.termPerformanceURL, urlForNotRegistrant: nil, alertTrigger: true)
            
        case "出欠記録":
            delegate.openUrl(urlForRegistrant: model.presenceAbsenceRecordURL, urlForNotRegistrant: nil, alertTrigger: true)
        case "パスワード設定":
            delegate.popupView(scene: "password")
            
        case "このアプリについて":
            delegate.popupView(scene: "aboutThisApp")
            
        case "開発者へ連絡":
            delegate.popupView(scene: "contactToDeveloper")
        default:
            return
        }
        
        viewAnimated(scene: "settingsViewDisappear")
    }


    



    


    


    
    /// 編集できるセクションを限定
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 { return false }
        return true
    }
}
