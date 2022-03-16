//
//  SettingsViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit
import FirebaseAnalytics

final class MenuViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    public var mainViewController : MainViewController?
    
    public let viewModel = MenuViewModel()
    private let dataManager = DataManager.singleton
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // チュートリアルを実行するべきか
        if dataManager.hadDoneTutorial == false {
            // チュートリアルを表示
            showTutorial()
            // チュートリアル完了とする(以降チュートリアルを表示しない)
            dataManager.hadDoneTutorial = true
            return
        }
    }
    
    // MARK: - Private func
    /// MenuViewControllerの初期セットアップ
    private func initSetup() {
        // 初期内容を読み込む
        viewModel.menuLists = dataManager.menuLists
        tableView.delegate = self
        tableView.reloadData()
    }

    /// チュートリアルを表示する
    ///
    /// 以下の順でボタンを疑似スポットライトをテキストと共に表示させる
    ///  1. 設定セル
    ///  2. パスワードセル
    ///  3. カスタマイズセル
    /// 画面をタップすることで次のスポットライト座標へ遷移する
    private func showTutorial() {
        let vc = MenuTutorialViewController()
        
        do { // 1. 設定セル
            // 設定のセルRowを取得する
            let row = viewModel.searchIndexCell(id: .setting)
            guard let row = row else {
                AKLog(level: .FATAL, message: "初期配列に設定が存在しない")
                fatalError()
            }
            // 相対座標(tableViewの左上をX=0,Y=0とした座標)
            let tableViewPos = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.tableCell, for: IndexPath(row: row, section: 0))! // fatalError
            // 絶対座標(画面左上X=0,Y=0からの座標)に変換
            let frame = tableView.convert(tableViewPos.frame, to: self.view)
            // スポットライトで照らす座標を追加する
            vc.uiLabels_frames.append(frame)
            // 表示テキストを追加する
            vc.textLabels.append("トクメモの目玉機能を\n設定しよう")
        }
        
        do { // 2. パスワードセル
            let row = viewModel.searchIndexCell(id: .password)
            guard let row = row else {
                AKLog(level: .FATAL, message: "初期配列にパスワードが存在しない")
                fatalError()
            }
            let tableViewPos1 = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.tableCell, for: IndexPath(row: row, section: 0))! // fatalError
            let frame = tableView.convert(tableViewPos1.frame, to: self.view)
            vc.uiLabels_frames.append(frame)
            vc.textLabels.append("自動ログイン機能を\n有効にしよう")
        }

        do { // 3. カスタマイズセル
            let row = viewModel.searchIndexCell(id: .customize)
            guard let row = row else {
                AKLog(level: .FATAL, message: "初期配列にカスタマイズが存在しない")
                fatalError()
            }
            let tableViewPos1 = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.tableCell, for: IndexPath(row: row, section: 0))! // fatalError
            let frame = tableView.convert(tableViewPos1.frame, to: self.view)
            vc.uiLabels_frames.append(frame)
            vc.textLabels.append("自分好みの設定を\n試してみよう")
        }
        // メニューボタンをスポットした後、メニュー画面を表示させる為に
        // インスタンス(のアドレス)を渡す
        vc.menuViewController = self
        present(vc, animated: true, completion: nil)
    }
    
    /// 図書館開館カレンダーの所在を選択させるポップアップを表示させる。
    ///
    /// - Note:
    ///   推奨されたAlertの使い方ではないので、今後修正する必要あり。
    /// - Parameter mainVC: MainViewControllerのインスタンス
    /// - Returns: 表示させるAlertの内容を返す
    private func makeLibrarySelector(_ mainVC: MainViewController) -> UIAlertController {
        var alert:UIAlertController!
        alert = UIAlertController(title: "", message: "図書館の所在を選択", preferredStyle: UIAlertController.Style.alert)
        
        let main = UIAlertAction(
            title: "常三島",
            style: UIAlertAction.Style.default,
            handler: { action in
                // 常三島のカレンダーURLを取得後、webView読み込み
                if let url = self.viewModel.makeLibraryCalendarUrl(type: .main) {
                    mainVC.webView.load(url)
                }else{
                    AKLog(level: .ERROR, message: "[URL取得エラー]: 常三島開館カレンダー")
                }
            })
        alert.addAction(main)
        
        let kura = UIAlertAction(
            title: "蔵本",
            style: UIAlertAction.Style.default,
            handler: { action in
                // 蔵本のカレンダーURLを取得後、webView読み込み
                if let url = self.viewModel.makeLibraryCalendarUrl(type: .kura) {
                    mainVC.webView.load(url)
                }else{
                    AKLog(level: .ERROR, message: "[URL取得エラー]: 蔵本開館カレンダー")
                }
            })
        alert.addAction(kura)
        return alert
    }
}


// MARK: - TableView
extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    /// セクション内のセル数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.menuLists.count
    }
    
    /// セルの中身
    ///
    /// - Note:
    ///  フォントサイズは17
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.tableCell, for: indexPath)! // fatalError
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        cell.textLabel?.text = viewModel.menuLists[indexPath.item].title
        return cell
    }
    
    /// セルの高さ
    ///
    /// - Note:
    ///  表示を許可されているCellの場合、高さを44とする
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.menuLists[indexPath.row].isDisplay {
            return 44
        }
        return 0
    }
    
    /// セルを選択時のイベント
    ///
    /// [設定]と[戻る]のセルでは、テーブルをリロードする。
    /// それ以外では画面を消した後、それぞれ処理を行う
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let mainVC = self.mainViewController else {
            AKLog(level: .FATAL, message: "[delegateエラー]: MainViewControllerから delegate=self を渡されていない")
            fatalError()
        }
        // タップされたセルの内容
        let cell = viewModel.menuLists[indexPath[1]]
        // どのセルが押されたか
        switch cell.id {
            case .setting: // 設定
                // メニューリストを設定用リストへ更新する
                viewModel.menuLists = Constant.initSettingLists
                tableView.reloadData()
                return
                
            case .buckToMenu: // 戻る
                // 設定用リストをメニューリストへ更新する
                viewModel.menuLists = Constant.initMenuLists
                tableView.reloadData()
                return
                
            default:
                break
        }
        // メニュー画面を消去後、画面を読み込む
        self.dismiss(animated: false, completion: {
            switch cell.id {
                case .libraryCalendar: // [図書館]開館カレンダー
                    let alert = self.makeLibrarySelector(mainVC)
                    mainVC.present(alert, animated: true, completion:nil)
                    
                case .currentTermPerformance: // 今年の成績
                    if let urlRequest = self.viewModel.createCurrentTermPerformanceUrl() {
                        mainVC.webView.load(urlRequest)
                    }else{
                        // トーストを表示したい
                    }
                    
                case .syllabus: // シラバス
                    self.dataManager.canExecuteJavascript = true
                    let vc = R.storyboard.syllabus.syllabusViewController()!
                    vc.delegate = mainVC
                    mainVC.present(vc, animated: true, completion: nil)
                    
                case .customize: // カスタマイズ画面
                    let vc = R.storyboard.customize.customizeViewController()!
                    mainVC.present(vc, animated: true, completion: nil)
                    
                case .initPageSetting: // 初期画面の設定画面
                    let vc = R.storyboard.initPageSetting.initPageSetting()!
                    mainVC.present(vc, animated: true, completion: nil)
                    
                case .password: // パスワード設定
                    let vc = R.storyboard.password.passwordViewController()!
                    vc.delegate = mainVC
                    mainVC.present(vc, animated: true, completion: nil)
                    
                case .aboutThisApp: // このアプリについて
                    let vc = R.storyboard.aboutThisApp.aboutThisAppViewController()!
                    mainVC.present(vc, animated: true, completion: nil)
                    
                case .mailService, .tokudaiCareerCenter: // メール(Outlook), キャリアセンター
                    self.dataManager.canExecuteJavascript = true
                    let urlString = cell.url!         // fatalError(url=nilは上記で網羅できているから)
                    let url = URL(string: urlString)! // fatalError
                    mainVC.webView.load(URLRequest(url: url))
                    
                default:
                    // それ以外はURLを読み込む
                    let urlString = cell.url!         // fatalError(url=nilは上記で網羅できているから)
                    let url = URL(string: urlString)! // fatalError
                    mainVC.webView.load(URLRequest(url: url))
            }
            // アナリティクスを送信
            Analytics.logEvent("MenuView", parameters: ["serviceName": cell.id]) // Analytics
        })
    }
}

extension MenuViewController {
    /// 画面をタップされた時の処理
    ///
    /// メニューエリア以外タップ時、画面をMainViewに戻す
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
