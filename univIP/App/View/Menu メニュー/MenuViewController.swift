//
//  SettingsViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit
import Gecco

final class MenuViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = MenuViewModel()
    private let dataManager = DataManager.singleton
    
    public var delegate : MainViewController?
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !dataManager.isFinishedMenuTutorial {
            // 完了していない場合、チュートリアルを表示
            // スポットライトチュートリアル
            tutorialSpotlight()
            // チュートリアル完了とする(以降チュートリアルを表示しない)
            dataManager.isFinishedMenuTutorial = true
        }
        
    }
    
    
    // MARK: - Private
    private func tutorialSpotlight() {
        let spotlightViewController = MenuTutorialSpotlightViewController()
        var passwordRow:Int?
        var customizeRow:Int?
        // 相対座標(tableViewの左上をX=0,Y=0とした座標)
        for i in 0..<Constant.initServiceLists.count {
            let id = Constant.initServiceLists[i].id
            if id == .password {
                passwordRow = i
            }
            if id == .cellSort {
                customizeRow = i
            }
        }
        
        guard let passR = passwordRow,
              let cusR = customizeRow else {
                  AKLog(level: .FATAL, message: "初期配列にパスワードかカスタマイズが存在しない")
                  return
              }
        
        let tableViewPos1 = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.tableCell, for: IndexPath(row: passR, section: 0))! // fatalError
        let tableViewPos2 = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.tableCell, for: IndexPath(row: cusR, section: 0))! // fatalError
        
        // 絶対座標(画面左上X=0,Y=0からの座標)に変換
        let pos1 = tableView.convert(tableViewPos1.frame, to: self.view)
        let pos2 = tableView.convert(tableViewPos2.frame, to: self.view)
        
        // スポットする座標を渡す
        spotlightViewController.uiLabels_frames.append(pos1)
        spotlightViewController.uiLabels_frames.append(pos2)
        
        spotlightViewController.delegateMenu = self
        present(spotlightViewController, animated: true, completion: nil)
    }
}


// MARK: - TableView
extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    // セクション内のセル数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.menuLists.count
    }
    
    // cellの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.tableCell, for: indexPath)! // fatalError
        tableCell.textLabel?.text = dataManager.menuLists[indexPath.item].title
        // 「17」程度が文字が消えず、また見やすいサイズ
        tableCell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        return tableCell
    }
    
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 表示を許可されているCellの場合、高さを44とする
        if dataManager.menuLists[indexPath.row].isDisplay {
            return 44
        }else{
            return 0
        }
    }
    
    // セルを選択した時のイベント
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let delegate = self.delegate else {
            AKLog(level: .FATAL, message: "[delegateエラー]: MainViewControllerから delegate=self を渡されていない")
            fatalError()
        }
        
        // JavaScriptを動かすことを許可する
        // JavaScriptを動かす必要がないCellでも、trueにしてOK(1度きりしか動かさないを判定するフラグだから)
        dataManager.isExecuteJavascript = true
        
        // メニュー画面を消去後、画面を読み込む
        self.dismiss(animated: false, completion: { [self] in
            // どのセルが押されたか
            switch self.dataManager.menuLists[indexPath[1]].id {
                case .libraryCalendar:                   // [図書館]開館カレンダー
                    delegate.showModalView(type: .libraryCalendar)
                    
                case .currentTermPerformance:            // 今年の成績
                    if let urlRequest = self.viewModel.createCurrentTermPerformanceUrl() {
                        delegate.webView.load(urlRequest)
                    }
                    
                case .syllabus:                          // シラバス
                    delegate.showModalView(type: .syllabus)
                    
                case .cellSort:                          // カスタマイズ画面
                    delegate.showModalView(type: .cellSort)
                    
                case .firstViewSetting:                  // 初期画面の設定画面
                    delegate.showModalView(type: .firstViewSetting)
                    
                case .password:                          // パスワード設定
                    delegate.showModalView(type: .password)
                    
                case .aboutThisApp:                      // このアプリについて
                    delegate.showModalView(type: .aboutThisApp)
                    
                default:
                    // 上記以外のCellをタップした場合
                    // Constant.Menu(構造体)のURLを表示する
                    let urlString = self.dataManager.menuLists[indexPath[1]].url!   // fatalError(url=nilは上記で網羅できているから)
                    let url = URL(string: urlString)!                               // fatalError
                    delegate.webView.load(URLRequest(url: url))
            }
            // アナリティクスを送信
            self.viewModel.analytics("\(self.dataManager.menuLists[indexPath[1]].id)")
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
