//
//  SettingsViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit

final class MenuViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    
    public var delegate : WebViewController?
    
    private let viewModel = MenuViewModel()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.delegate = self
    }
    
    // メニューエリア以外タップ時、画面をMainViewに戻す
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        // 画面をタップした時
        for touch in touches {
            // どの画面がタップされたかtagで判定
            if touch.view?.tag == 1 {
                dismiss(animated: false, completion: nil)
            }
        }
    }
}

//extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.menuLists.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let tableCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.tableCell, for: indexPath)! // fatalError
//        let menuLists = viewModel.menuLists
//        tableCell.textLabel?.text = menuLists[indexPath.item].title
//        tableCell.textLabel?.font = UIFont.systemFont(ofSize: 17)
//        return tableCell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 44
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let delegate = self.delegate else {
//            AKLog(level: .FATAL, message: "[delegateエラー]: WebViewControllerから delegate=self を渡されていない")
//            fatalError()
//        }
//        dataManager.canExecuteJavascript = true
//        self.dismiss(animated: false, completion: { [self] in
//            let urlString = self.viewModel.menuLists[indexPath[1]].url!   // fatalError(url=nilは上記で網羅できているから)
//            let url = URL(string: urlString)!
//            delegate.webView.load(URLRequest(url: url))
//        })
//    }
//}
