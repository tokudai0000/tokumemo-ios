//
//  SettingsViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/10/15.
//

import UIKit

final class SettingsViewController: UIViewController {
    @IBOutlet var tableView: UITableView!

    var viewModel: SettingsViewModelInterface!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ItemsConstants().settingsItems.count
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
        return ItemsConstants().settingsItems[section].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingCell, for: indexPath)!
        cell.textLabel?.text = ItemsConstants().settingsItems[indexPath.section][indexPath.item].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.input.didTapSettingsItem.accept(indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
