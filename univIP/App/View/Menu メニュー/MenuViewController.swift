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
    
    public var delegate : MainViewController?
    private let viewModel = MenuViewModel()
    private let dataManager = DataManager.singleton
    // TableCellの内容
    private var menuLists:[Constant.Menu] = []
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初期内容を読み込む
        menuLists = dataManager.menuLists
        tableView.delegate = self
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // チュートリアルを実行するべきか
        if dataManager.shouldShowTutorial {
            tutorialSpotlight()
            // チュートリアル完了とする(以降チュートリアルを表示しない)
            dataManager.shouldShowTutorial = false
        }
    }
    
    public func changeToSettings() {
        menuLists = Constant.initSettingLists
        tableView.reloadData()
    }
    
    // MARK: - Private
    private func tutorialSpotlight() {
        let spotlightViewController = MenuTutorialSpotlightViewController()
        // 設定のセルRowを取得する
        var settingRow:Int?
        for i in 0..<menuLists.count {
            if menuLists[i].id == .setting {
                settingRow = i
                break
            }
        }
        // 初期配列に設定が存在しないことはありえない
        guard let settingRow = settingRow else {
            AKLog(level: .FATAL, message: "初期配列に設定が存在しない")
            fatalError()
        }
        // パスワードとカスタマイズのセルRowを取得する
        var passwordRow:Int?
        var customizeRow:Int?
        for i in 0..<Constant.initSettingLists.count {
            let id = Constant.initSettingLists[i].id
            if id == .password { passwordRow = i }
            if id == .cellSort { customizeRow = i }
        }
        // 初期配列にパスワードかカスタマイズが存在しないことはありえない
        guard let passR = passwordRow,
              let cusR = customizeRow else {
                  AKLog(level: .FATAL, message: "初期配列にパスワードかカスタマイズが存在しない")
                  return
              }
        
        // 相対座標(tableViewの左上をX=0,Y=0とした座標)
        let tableViewPos = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.tableCell, for: IndexPath(row: settingRow, section: 0))! // fatalError
        let tableViewPos1 = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.tableCell, for: IndexPath(row: passR, section: 0))! // fatalError
        let tableViewPos2 = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.tableCell, for: IndexPath(row: cusR, section: 0))! // fatalError
        
        // 絶対座標(画面左上X=0,Y=0からの座標)に変換
        let pos = tableView.convert(tableViewPos.frame, to: self.view)
        let pos1 = tableView.convert(tableViewPos1.frame, to: self.view)
        let pos2 = tableView.convert(tableViewPos2.frame, to: self.view)
        // スポットする座標を渡す
        spotlightViewController.uiLabels_frames.append(pos)
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
        return menuLists.count
    }
    
    // cellの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.tableCell, for: indexPath)! // fatalError
        tableCell.textLabel?.text = menuLists[indexPath.item].title
        // 「17」程度が文字が消えず、また見やすいサイズ
        tableCell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        return tableCell
    }
    
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 表示を許可されているCellの場合、高さを44とする
        if menuLists[indexPath.row].isDisplay {
            return 44
        }else{
            return 0
        }
    }
    
    // セルを選択した時のイベント
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if menuLists[indexPath[1]].id == .setting {
            changeToSettings()
            return
        }
        if menuLists[indexPath[1]].id == .buckToMenu {
            menuLists = Constant.initMenuLists
            tableView.reloadData()
            return
        }
        
        guard let delegate = self.delegate else {
            AKLog(level: .FATAL, message: "[delegateエラー]: MainViewControllerから delegate=self を渡されていない")
            fatalError()
        }
        
        // JavaScriptを動かすことを許可する
        // JavaScriptを動かす必要がないCellでも、trueにしてOK(1度きりしか動かさないを判定するフラグだから)
        dataManager.canExecuteJavascript = true
        
        // メニュー画面を消去後、画面を読み込む
        self.dismiss(animated: false, completion: { [self] in
            // どのセルが押されたか
            switch self.menuLists[indexPath[1]].id {
                case .libraryCalendar:                   // [図書館]開館カレンダー
                    // MARK: - HACK 推奨されたAlertの使い方ではない
                    // 常三島と蔵本を選択させるpopup(**Alert**)を表示 **推奨されたAlertの使い方ではない為、修正すべき**
                    var alert:UIAlertController!
                    //アラートコントローラーを作成する。
                    alert = UIAlertController(title: "", message: "図書館の所在を選択", preferredStyle: UIAlertController.Style.alert)
                    
                    let alertAction = UIAlertAction(
                        title: "常三島",
                        style: UIAlertAction.Style.default,
                        handler: { action in
                            let urlString = Url.libraryHomePageMainPC.string()
                            let url = URL(string: urlString)! // fatalError
                            // 常三島のカレンダーURLを取得後、webView読み込み
                            if let url = viewModel.makeLibraryCalendarUrl(type: .main) {
                                delegate.webView.load(url)
                            }else{
                                AKLog(level: .ERROR, message: "[URL取得エラー]: 常三島開館カレンダー")
                            }
                        })
                    
                    let alertAction2 = UIAlertAction(
                        title: "蔵本",
                        style: UIAlertAction.Style.default,
                        handler: { action in
                            let urlString = Url.libraryHomePageKuraPC.string()
                            let url = URL(string: urlString)! // fatalError
                            // 蔵本のカレンダーURLを取得後、webView読み込み
                            if let url = viewModel.makeLibraryCalendarUrl(type: .kura) {
                                delegate.webView.load(url)
                            }else{
                                AKLog(level: .ERROR, message: "[URL取得エラー]: 蔵本開館カレンダー")
                            }
                        })
                    
                    //アラートアクションを追加する。
                    alert.addAction(alertAction)
                    alert.addAction(alertAction2)
                    delegate.present(alert, animated: true, completion:nil)
                    
                case .currentTermPerformance:            // 今年の成績
                    if let urlRequest = self.viewModel.createCurrentTermPerformanceUrl() {
                        delegate.webView.load(urlRequest)
                    }
                    
                case .syllabus:                          // シラバス
//                    delegate.showModalView(type: .syllabus)
                    let vc = R.storyboard.syllabus.syllabusViewController()!
                    vc.delegate = delegate
                    delegate.present(vc, animated: true, completion: nil)
                    
                case .cellSort:                          // カスタマイズ画面
                    let vc = R.storyboard.cellSort.cellSort()!
                    delegate.present(vc, animated: true, completion: nil)
                    
                case .firstViewSetting:                  // 初期画面の設定画面
                    let vc = R.storyboard.firstViewSetting.firstViewSetting()!
                    delegate.present(vc, animated: true, completion: nil)
                    
                case .password:                          // パスワード設定
                    let vc = R.storyboard.passwordSettings.passwordSettingsViewController()!
                    vc.delegate = delegate
                    delegate.present(vc, animated: true, completion: nil)
                    
                case .aboutThisApp:                      // このアプリについて
                    let vc = R.storyboard.aboutThisApp.aboutThisApp()!
                    delegate.present(vc, animated: true, completion: nil)
                    
                default:
                    // 上記以外のCellをタップした場合
                    // Constant.Menu(構造体)のURLを表示する
                    let urlString = self.menuLists[indexPath[1]].url!   // fatalError(url=nilは上記で網羅できているから)
                    let url = URL(string: urlString)!                               // fatalError
                    delegate.webView.load(URLRequest(url: url))
            }
            // アナリティクスを送信
            self.viewModel.analytics("\(self.menuLists[indexPath[1]].id)")
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
