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
//    @IBOutlet weak var menuView: UIView!
    
    
    private let module = Module()
    
//    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        switch item.tag {
//        case 1:
//            openUrl(urlString: module.courceManagementHomeURL)
//        case 2:
//            openUrl(urlString: module.manabaURL)
//        case 3:
//            let vc = R.storyboard.settings.settingsViewController()!
//            self.present(vc, animated: true, completion: nil)
//        default:
//            return
//        }
//    }
    // セルの内容が入る
    private var cellList:[[String]] = [["図書館サイト", "シラバス", "時間割", "今期の成績表", "出欠記録"], ["パスワード設定", "このアプリについて", "開発者へ連絡"]]
    // セクションの高さ
    private var sectionHight:Int = 50
    // セルの高さ
    private var cellHight:Int = 100

//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(false)
//        // メニューの位置を取得する
//        let menuPos = self.menuView.layer.position
//        // 初期位置を画面の外側にするため、メニューの幅の分だけマイナスする
//        self.menuView.layer.position.x = -self.menuView.frame.width
//        // 表示時のアニメーションを作成する
//        UIView.animate(
//            withDuration: 0.5,
//            delay: 0,
//            options: .curveEaseOut,
//            animations: {
//                self.menuView.layer.position.x = menuPos.x
//            },
//            completion: { bool in
//            })
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK:- @IBAction
    @IBAction func homeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: - Library
    /// セルを選択した時のイベントを追加
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath[0] == 0 && indexPath[1] == 0){ // パスワード設定
            let vc = R.storyboard.passWordSettings.passWordSettingsViewController()!
            self.present(vc, animated: true, completion: nil)
        }else if (indexPath[0] == 1 && indexPath[1] == 0){ // このアプリについて
            let vc = R.storyboard.aboutThisApp.aboutThisAppViewController()!
            self.present(vc, animated: true, completion: nil)
        }else if (indexPath[0] == 1 && indexPath[1] == 1){ // 開発者へ連絡
            let vc = R.storyboard.contactToDeveloper.contactToDeveloperViewController()!
            self.present(vc, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
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

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // メニューの位置を取得する
        let menuPos = self.tableView.layer.position
//        let menuPos = self.menuView.layer.position
        // 初期位置を画面の外側にするため、メニューの幅の分だけマイナスする(スタート地)
        self.tableView.layer.position.x = -self.tableView.frame.width
//        self.menuView.layer.position.x = -self.menuView.frame.width
        // 表示時のアニメーションを作成する
        print(menuPos.x)
        print(-self.tableView.frame.width)
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.tableView.layer.position.x = 0 //menuPos.x
//                self.menuView.layer.position.x = menuPos.x
        },
            completion: { bool in
        })
        
    }

    // メニューエリア以外タップ時の処理
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            if touch.view?.tag == 1 {
                UIView.animate(
                    withDuration: 0.2,
                    delay: 0,
                    options: .curveEaseIn,
                    animations: {
                        self.tableView.layer.position.x = -self.tableView.frame.width
//                        self.menuView.layer.position.x = -self.menuView.frame.width
                },
                    completion: { bool in
                        self.dismiss(animated: false, completion: nil)
                }
                )
                
            }
        }
    }
    
}


