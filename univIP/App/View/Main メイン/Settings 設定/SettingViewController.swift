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
    
    @IBOutlet var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // カスタマイズ画面から戻ってきた場合、選択状態を解除する
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
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
            return "毎日面倒だったマナバなどへのログインを自動化します"
        }
        return " "
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
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
                let vc = R.storyboard.input.inputViewController()!
                vc.type = .password
                navigationController?.pushViewController(vc, animated: true)
                
            case .favorite:
                let vc = R.storyboard.input.inputViewController()!
                vc.type = .favorite
                navigationController?.pushViewController(vc, animated: true)
//                let vc = R.storyboard.favorite.favoriteViewController()!
//                vc.title = "お気に入り登録"
//                navigationController?.pushViewController(vc, animated: true)
                
            case .customize:
                let vc = R.storyboard.customize.customizeViewController()!
                vc.title = "カスタマイズ"
                navigationController?.pushViewController(vc, animated: true)
                
            default:
                let vc = R.storyboard.web.webViewController()!
                vc.loadUrlString = cell.url!
                present(vc, animated: true, completion: nil)
        }
        Analytics.logEvent("SettingCell[\(cell.id)]", parameters: nil) // Analytics
    }
}
