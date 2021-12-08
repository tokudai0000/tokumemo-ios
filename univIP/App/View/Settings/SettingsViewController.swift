//
//  SettingsViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit

final class SettingsViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = SettingViewModel()
    private let dataManager = DataManager.singleton
    
    public var delegate : MainViewController?
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // viewをタップされた際の処理
        let tap = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.viewTap(_:)))
        self.view.addGestureRecognizer(tap)
        
        viewModel.initialBootProcess()
        self.tableView.reloadData()
    }
    
    @objc func viewTap(_ sender: UITapGestureRecognizer) {
        dismiss(animated: false, completion: nil)
    }
}


// MARK: - TableView
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - HACK
    /// セクションの高さ
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 0 }
        return 1
    }
    
    /// セクション数
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataManager.allCellList.count
    }
    
    // セクションの背景とテキストの色を変更する
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .gray
    }
    
    /// セクション内のセル数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.allCellList[section].count
    }
    
    /// cellの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.tableCell, for: indexPath)!
        tableCell.textLabel!.text = dataManager.allCellList[indexPath.section][indexPath.item].title
        // 「17」程度が文字が消えず、また見やすいサイズ
        tableCell.textLabel!.font = UIFont.systemFont(ofSize: 17)
        return tableCell
    }
    
    /// セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if dataManager.allCellList[indexPath.section][indexPath.row].isDisplay {
            return 44
        }
        return 0
    }
    
    /// セルを選択した時のイベント
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: false, completion: nil)
        
        guard let delegate = delegate else {
            return
        }
        
        switch dataManager.allCellList[indexPath[0]][indexPath[1]].type {
        case .libraryCalendar:                   // [図書館]開館カレンダー
            if let url = viewModel.fetchLibraryCalenderUrl() {
                delegate.webView.load(url)
            }
            
        case .currentTermPerformance:            // 今年の成績
            delegate.webView.load(viewModel.createCurrentTermPerformanceUrl())
            
        case .syllabus:                          // シラバス
            delegate.showModalView(type: .syllabus)
            
        case .cellSort:
            delegate.showModalView(type: .cellSort)
            
        case .password:                          // パスワード設定
            delegate.showModalView(type: .password)
            
        case .aboutThisApp:                      // このアプリについて
            delegate.showModalView(type: .aboutThisApp)
            
        default:
            if let url = URL(string: dataManager.allCellList[indexPath[0]][indexPath[1]].url) {
                delegate.webView.load(URLRequest(url: url))
            } else {
                AKLog(level: .FATAL, message: "URLフォーマットエラー")
                fatalError()
            }
        }
    }
}
