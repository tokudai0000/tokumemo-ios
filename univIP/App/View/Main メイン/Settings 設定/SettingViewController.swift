//
//  SettingViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/10/15.
//

import UIKit
import FirebaseAnalytics

final class SettingViewController: UIViewController {
    
    private let viewModel = SettingViewModel()
    
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.white
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.settingLists.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "このアプリでは、パスワードを保存することで毎日面倒だったマナバなどへのログインを自動化します。パスワード設定から機能をオンにしてみましょう。"
        }
        return " "
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 65 }
        return 30
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.settingLists[section].count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingCell, for: indexPath)! // fatalError
        cell.textLabel?.text = viewModel.settingLists[indexPath.section][indexPath.item].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = viewModel.settingLists[indexPath.section][indexPath[1]]
        switch cell.id {
            case .password:
                let vc = R.storyboard.password.passwordViewController()!
                vc.title = "パスワード"
                navigationController?.pushViewController(vc, animated: true)
                
            case .favorite:
                let vc = R.storyboard.favorite.favoriteViewController()!
                vc.title = "お気に入り登録"
                navigationController?.pushViewController(vc, animated: true)
                
            case .customize:
                let vc = R.storyboard.customize.customizeViewController()!
                vc.title = "カスタマイズ"
                navigationController?.pushViewController(vc, animated: true)
                
            default:
                let vc = R.storyboard.web.webViewController()!
                vc.loadUrlString =  cell.url!
                present(vc, animated: true, completion: nil)
        }
        Analytics.logEvent("SettingCell[\(cell.id)]", parameters: nil) // Analytics
    }
}
