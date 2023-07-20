//
//  SettingViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/10/15.
//

import UIKit

final class SettingViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet var tableView: UITableView!
    
    private let viewModel = SettingViewModel()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.settingItemLists.count
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
        return viewModel.settingItemLists[section].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingCell, for: indexPath)!
        cell.textLabel?.text = viewModel.settingItemLists[indexPath.section][indexPath.item].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = viewModel.settingItemLists[indexPath.section][indexPath[1]]
        switch cell.id {
        case .password:
            let vc = R.storyboard.input.inputViewController()!
            vc.type = .password
            navigationController?.pushViewController(vc, animated: true)
        case .favorite:
            let vc = R.storyboard.input.inputViewController()!
            vc.type = .favorite
            navigationController?.pushViewController(vc, animated: true)
        case .customize:
            let vc = R.storyboard.customize.customizeViewController()!
            vc.title = "カスタマイズ"
            navigationController?.pushViewController(vc, animated: true)
        default:
            let vc = R.storyboard.web.webViewController()!
            vc.loadUrlString = cell.url!
            present(vc, animated: true, completion: nil)
        }
    }
}
