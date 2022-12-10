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
    private let dataManager = DataManager.singleton
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
    }
}


// MARK: - TableView
extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    // セクション内のセル数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.loadMenu().count
    }
    
    // cellの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.tableCell, for: indexPath)! // fatalError
        let menuLists = dataManager.loadMenu()
        tableCell.textLabel?.text = menuLists[indexPath.item].title
        // 「17」程度が文字が消えず、また見やすいサイズ
        tableCell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        return tableCell
    }
    
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 表示を許可されているCellの場合、高さを44とする
        if dataManager.loadMenu()[indexPath.row].isHiddon {
            return 0
        }else{
            return 44
        }
    }
    
    // セルを選択した時のイベント
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let delegate = self.delegate else {
            AKLog(level: .FATAL, message: "[delegateエラー]: WebViewControllerから delegate=self を渡されていない")
            fatalError()
        }
        
        // JavaScriptを動かすことを許可する
        // JavaScriptを動かす必要がないCellでも、trueにしてOK(1度きりしか動かさないを判定するフラグだから)
        dataManager.canExecuteJavascript = true
        
        // メニュー画面を消去後、画面を読み込む
        self.dismiss(animated: false, completion: { [self] in
            // どのセルが押されたか
            switch self.dataManager.loadMenu()[indexPath[1]].id {
                case .currentTermPerformance:            // 今年の成績
                    if let urlRequest = self.viewModel.createCurrentTermPerformanceUrl() {
                        delegate.webView.load(urlRequest)
                    }
                    
                default:
                    // 上記以外のCellをタップした場合
                    // Constant.Menu(構造体)のURLを表示する
                    let urlString = self.dataManager.loadMenu()[indexPath[1]].url!   // fatalError(url=nilは上記で網羅できているから)
                    let url = URL(string: urlString)!                               // fatalError
                    delegate.webView.load(URLRequest(url: url))
            }
            // アナリティクスを送信
            self.viewModel.analytics("\(self.dataManager.loadMenu()[indexPath[1]].id)")
        })
    }
}

// MARK: - Override(Animate)
extension MenuViewController {
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
