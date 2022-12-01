//
//  OthersViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/10/15.
//

import UIKit
import FirebaseAnalytics


class SettingsViewController: UITableViewController {
    
    /// TableCellの内容
    private var collectionLists:[[ConstStruct.SettingsCell]] = ConstStruct.initSettingsCellLists
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return collectionLists.count
    }
    
    override func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        // パスワードのセクションに説明文を追加
        if section == 0 {
            return "このアプリでは、パスワードを保存することで毎日面倒だったマナバなどへのログインを自動化します。パスワード設定から機能をオンにしてみましょう。"
        }
        return " "
    }

    /// セクションの高さ
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 65
        }
        return 30
    }
    
    /// セルの数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectionLists[section].count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.white
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.othersCell, for: indexPath)! // fatalError
        
        cell.textLabel?.text = collectionLists[indexPath.section][indexPath.item].title

        return cell
    }
    
    
    /// セルを選択時のイベント
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // タップされたセルの内容
        let cell = collectionLists[indexPath.section][indexPath[1]]
        let vcWeb = R.storyboard.web.webViewController()!
        
        // アナリティクスを送信
        Analytics.logEvent("SettingsCell[\(cell.id)]", parameters: nil) // Analytics

        // どのセルが押されたか
        switch cell.id {
            case .password:
                let vc = R.storyboard.password.passwordViewController()!
                vc.title = "パスワード"
                navigationController?.pushViewController(vc, animated: true)
                return
                
            case .customize:
                let vc = R.storyboard.customize.customizeViewController()!
                vc.title = "カスタマイズ"
                navigationController?.pushViewController(vc, animated: true)
                return
                
            case .aboutThisApp:
                let vc = R.storyboard.aboutThisApp.aboutThisAppViewController()!
                vc.title = "このアプリについて"
                navigationController?.pushViewController(vc, animated: true)
                return
                
            case .contactUs:
                vcWeb.loadUrlString = Url.contactUs.string()
                
            case .officialSNS:
                vcWeb.loadUrlString = Url.officialSNS.string()
                
            case .homePage:
                vcWeb.loadUrlString = Url.homePage.string()
                
            case .termsOfService:
                vcWeb.loadUrlString = Url.termsOfService.string()
                
            case .privacyPolicy:
                vcWeb.loadUrlString = Url.privacyPolicy.string()
                
            case .sourceCode:
                vcWeb.loadUrlString = Url.sourceCode.string()
                
            default:
                break
        }
        present(vcWeb, animated: true, completion: nil)
    }
}
