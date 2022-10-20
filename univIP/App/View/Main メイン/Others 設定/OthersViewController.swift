//
//  OthersViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/10/15.
//

import UIKit

class OthersViewController: UITableViewController {

    private let viewModel = OthersViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.collectionLists.count
    }
    
    override func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        return " "
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.collectionLists[section].count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.white
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.othersCell, for: indexPath)! // fatalError
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        cell.textLabel?.text = viewModel.collectionLists[indexPath.section][indexPath.item].title

        return cell
    }
    
    
    /// セルを選択時のイベント
    ///
    /// [設定]と[戻る]のセルでは、テーブルをリロードする。
    /// それ以外では画面を消した後、それぞれ処理を行う
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // タップされたセルの内容
        let cell = viewModel.collectionLists[indexPath.section][indexPath[1]]
        // どのセルが押されたか
        switch cell.id {
            case .password:
                let storyboard: UIStoryboard = UIStoryboard(name: "Password", bundle: nil)//遷移先のStoryboardを設定
                let nextView = storyboard.instantiateViewController(withIdentifier: "PasswordViewController") as! PasswordViewController//遷移先のViewControllerを設定
                nextView.title = "パスワード"
                self.navigationController?.pushViewController(nextView, animated: true)//遷移する
                return
                
            case .aboutThisApp:
                let storyboard: UIStoryboard = UIStoryboard(name: "AboutThisApp", bundle: nil)//遷移先のStoryboardを設定
                let nextView = storyboard.instantiateViewController(withIdentifier: "AboutThisAppViewController") as! AboutThisAppViewController//遷移先のViewControllerを設定
                nextView.title = "このアプリについて"
                self.navigationController?.pushViewController(nextView, animated: true)//遷移する
                return
                
            default:
                break
        }
    }
}
