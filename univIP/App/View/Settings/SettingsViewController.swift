//
//  SettingsViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    //２次元配列　セルの内容が入る
    var cellList:[[String]] = [["パスワード設定"],
                               ["[通知]講義についての通知",
                                "[通知]就職についての通知",
                                "[通知]その他の通知",
                                "授業アンケート催促をスキップ"],
                                ["このアプリについて",
                                 "開発者へ連絡"]]
    //セクションの名前が入る
    var sectionTitles:[String] = ["a","v","d"]
    //セクションの数
    var sectionNum = 3
    //セクションの高さ
    var sectionHight:Int = 50
    //セルの数
    var cellNum:Int = 0
    //セルの高さ
    var cellHight:Int = 100
    //セクション番号
    var indexPath_section:Int = 0
    //セル番号
    var indexPath_row:Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//    /*
//    セルを選択した時のイベントを追加
//    */
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        indexPath_section = indexPath.section //記憶させてCellTapped.swiftで使う
//        indexPath_row = indexPath.row
//        //同じstororyboard内であることをここで定義
//        let storyboard: UIStoryboard = self.storyboard!
//        //移動先のstoryboardを選択(Identifierを指定する)
//        let second = storyboard.instantiateViewController(withIdentifier: "cellTapped")
//        //実際に移動するコード
//        self.present(second, animated: true, completion: nil)
//    }
//
    
    
    
    /*
    セクション内のセル数を決めるメソッド（＊＊必須＊＊）
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellList[Int(section)].count
    }
    /*
    セルのインスタンスを生成するメソッド「表示するcellの中身を決める」（＊＊必須＊＊）
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let TableCell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
        TableCell.textLabel!.text = cellList[indexPath.section][Int(indexPath.item)]
        return TableCell
    }

    /*
     テーブル内のセクション数を決めるメソッド
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNum
    }

    /*
    セクションの高さを設定
    */
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(sectionHight)
    }

    /*
    セルの高さを決めるメソッド
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHight)
    }
    
    
    @IBAction func homeButton(_ sender: Any) {
        let vc = R.storyboard.main.mainViewController()!
        self.present(vc, animated: true, completion: nil)
    }

}
