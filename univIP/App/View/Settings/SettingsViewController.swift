//
//  SettingsViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {
    //MARK:- @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    private let module = Module()
    // セルの内容が入る
    private var cellList:[[String]] = [["図書館サイト",
                                        "シラバス",
                                        "時間割",
                                        "今年の成績表",
                                        "出欠記録"],
                                       ["パスワード設定",
                                        "このアプリについて",
                                        "開発者へ連絡"]]
    // セクションの高さ
    private var sectionHight:Int = 50
    // セルの高さ
    private var cellHight:Int = 100
    
    var delegateMain : MainViewController?
    var delegatePass : PassWordSettingsViewController?

    
    //MARK:- LifeCycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        viewAnimated(scene: "settingsViewAppear")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    // MARK: - Library
    /// セルを選択した時のイベントを追加
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: false, completion: nil)
        self.delegateMain?.restoreView()
        
        if (indexPath[0] == 0){
            switch indexPath[1] {
            case 0: // 図書館サイト
                self.delegateMain?.reloadURL(urlString: module.liburaryURL)
            case 1: // シラバス
                self.delegateMain?.popupSyllabus()
            case 2: // 時間割
                self.delegateMain?.reloadURL(urlString: module.timeTableURL)
            case 3: // 今年の成績
                self.delegateMain?.reloadURL(urlString: module.currentTermPerformanceURL)
            case 4: // 出欠記録
                self.delegateMain?.reloadURL(urlString: module.presenceAbsenceRecordURL)
            default:
                return
            }
        }else if(indexPath[0] == 1){
            switch indexPath[1] {
            case 0: // パスワード設定
                self.delegateMain?.popupPassWordView()
            case 1: // このアプリについて
                self.delegateMain?.popupAboutThisApp()
            case 2: // 開発者へ連絡
                self.delegateMain?.popupContactToDeveloper()
            default:
                return
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    
        viewAnimated(scene: "settingsViewDisappear")
    }

    /// セクション内のセル数を決めるメソッド（＊＊必須＊＊）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellList[Int(section)].count
    }
    
    /// セルのインスタンスを生成するメソッド「表示するcellの中身を決める」（＊＊必須＊＊）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let TableCell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
        TableCell.textLabel!.text = cellList[indexPath.section][Int(indexPath.item)]
        TableCell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator // ここで「>」ボタンを設定
        return TableCell
    }

    /// テーブル内のセクション数を決めるメソッド
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellList.count
    }

    /// セクションの高さを設定
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(sectionHight)
    }

    /// セルの高さを決めるメソッド
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHight)
    }
    
    //MARK:- Private func
    private func viewAnimated(scene:String){
        switch scene {
        case "settingsViewAppear":
            // メニューの位置を取得する
            let menuPos = self.tableView.layer.position
            // 初期位置を画面の外側にするため、メニューの幅の分だけマイナスする
            self.tableView.layer.position.x = -self.tableView.frame.width
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                options: .curveEaseOut,
                animations: {
                    self.tableView.layer.position.x = menuPos.x
            },
                completion: { bool in
            })
        case "settingsViewDisappear":
            UIView.animate(
                withDuration: 0.5,
                delay: 0.07,
                options: .curveEaseIn,
                animations: {
                    self.tableView.layer.position.x = -self.tableView.frame.width
                },
                completion: { bool in
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
                self.dismiss(animated: false, completion: nil)
//                self.delegateMain?.restoreView()
//                self.delegatePass?.restoreView()
            }
        }
    }
}


