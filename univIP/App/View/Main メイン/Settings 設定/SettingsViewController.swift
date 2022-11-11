//
//  OthersViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/10/15.
//

import UIKit
import SafariServices

class SettingsViewController: UITableViewController {

    @IBOutlet weak var discriptionLabel: UILabel!
    
    private let viewModel = SettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        discriptionLabel.text = "このアプリでは、パスワードを保存することで毎日面倒だったmanabaなどへのログインを自動化します。パスワード設定から機能をオンにしてみましょう。"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.collectionLists.count
    }
    
    override func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "このアプリでは、パスワードを保存することで毎日面倒だったマナバなどへのログインを自動化します。パスワード設定から機能をオンにしてみましょう。"
        }
        return " "
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 65
        }
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
        

//        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
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
        let vcWeb = R.storyboard.web.webViewController()!

        // どのセルが押されたか
        switch cell.id {
            case .password:
                let storyboard: UIStoryboard = UIStoryboard(name: "Password", bundle: nil)//遷移先のStoryboardを設定
                let nextView = storyboard.instantiateViewController(withIdentifier: "PasswordViewController") as! PasswordViewController//遷移先のViewControllerを設定
                nextView.title = "パスワード"
                self.navigationController?.pushViewController(nextView, animated: true)//遷移する
                return
                
            case .customize:
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
                
            case .contactUs:
                vcWeb.loadUrlString = "https://forms.gle/ceBzS6TL3A1XuJsNA"
                
            case .officialSNS:
                vcWeb.loadUrlString = "https://twitter.com/tokumemo0000"
                
            case .homePage:
                vcWeb.loadUrlString = "https://lit.link/developers"
                
            case .termsOfService:
                vcWeb.loadUrlString = "https://github.com/tokudai0000/document/blob/main/tokumemo/terms/TermsOfService.txt"
                
            case .privacyPolicy:
                vcWeb.loadUrlString = "https://github.com/tokudai0000/document/blob/main/tokumemo/terms/PrivacyPolicy.txt"
                
//            case .license:
//                vcWeb.loadUrlString = "https://www.google.com/?hl=ja"
//
//            case .acknowledgments:
//                vcWeb.loadUrlString = "https://www.google.com/?hl=ja"
                
            case .sourceCode:
                vcWeb.loadUrlString = "https://github.com/tokudai0000/univIP"
                
            default:
                break
        }
        present(vcWeb, animated: true, completion: nil)
    }
}
