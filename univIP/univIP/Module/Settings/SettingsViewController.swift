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

    private let itemsConstants = ItemsConstants()
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemsConstants.settingsItems.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "毎日面倒だったマナバなどへのログインを自動化します" : " "
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsConstants.settingsItems[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingCell, for: indexPath) else {
            return UITableViewCell()
        }
        cell.textLabel?.text = itemsConstants.settingsItems[indexPath.section][indexPath.item].title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.input.didTapSettingsItem.accept(indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
