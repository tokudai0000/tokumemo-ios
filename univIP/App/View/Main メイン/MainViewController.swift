//
//  WebViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit
import WebKit
import FirebaseAnalytics

final class MainViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var adImageView: UIImageView!
    @IBOutlet weak var weatherWebView: WKWebView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // 自動ログインをメイン画面(Home画面)中に完了させるために、サイズ0で表示はされないが読み込みや通信は行なっている。
    @IBOutlet weak var forLoginWebView: WKWebView!
    
    private let viewModel = MainViewModel()
    private let dataManager = DataManager.singleton
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
        // デバックの時にいじる部分
        // dataManager.hadDoneTutorial = false
        #endif
        
        // collectionViewの初期設定
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CustomCell", bundle: nil), forCellWithReuseIdentifier: "CustomCell")
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        collectionView.collectionViewLayout = layout
        
        // forLoginWebViewの初期設定
        forLoginWebView.navigationDelegate = self
        // ログインページの読み込み
        loadLoginPage()
        
        // weatherWebViewの初期設定(滅多に出ない雹や雪などの天気アイコンを作るよりWebページを表示した方が早いし正確との判断から)
        weatherWebView.load(URLRequest(url: URL(string: "https://www.jma.go.jp/bosai/forecast/img/201.svg")!)) // 気象庁のAPIから天気アイコンのURLを変更できるようにする
        weatherWebView.pageZoom = 3
        weatherWebView.isUserInteractionEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 利用規約同意画面を表示するべきか
        if viewModel.shouldShowTermsAgreementView {
            // 利用規約同意画面を表示
            let vc = R.storyboard.agreement.agreementViewController()!
            present(vc, animated: false, completion: nil)
            return
        }
    }
    
    // MARK: - IBAction
    @IBAction func studentCardButton(_ sender: Any) {
        Analytics.logEvent("StudentCardButton", parameters: nil) // Analytics
    }
    
    // MARK: - Private func
    /// 大学統合認証システム(IAS)のページを読み込む
    /// ログインの処理はWebViewのdidFinishで行う
    private func loadLoginPage() {
        // ログイン用のJavaScriptを動かす為のフラグ
        dataManager.canExecuteJavascript = true
        // ログイン処理中であるフラグ
        viewModel.isLoginProcessing = true
        // 大学統合認証システムのログインページを読み込む
        forLoginWebView.load(Url.universityTransitionLogin.urlRequest())
    }
}


// MARK: - WKNavigationDelegate
extension MainViewController: WKNavigationDelegate {
    /// 読み込み設定（リクエスト前）
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // 読み込み前のURLをアンラップ
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            AKLog(level: .FATAL, message: "読み込み前のURLをアンラップ失敗")
            return
        }
        
        // タイムアウトした場合
        if viewModel.shouldReLogin(url.absoluteString) {
            // 再度ログイン処理を行う
            loadLoginPage()
        }
        
        // 問題ない場合読み込みを許可
        decisionHandler(.allow)
        return
    }
    
    /// 読み込み完了
    ///
    /// 主に以下のことを処理する
    ///  1. JavaScriptを動かしたいURLかどうかを判定し、必要なら動かす
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 読み込み完了したURL
        let url = self.forLoginWebView.url! // fatalError
        
        // JavaScriptを動かしたいURLかどうかを判定し、必要なら動かす
        switch viewModel.anyJavaScriptExecute(url.absoluteString) {
                
            case .loginIAS:
                // 徳島大学　統合認証システムサイト(ログインサイト)
                // 自動ログインを行う。JavaScriptInjection
                webView.evaluateJavaScript("document.getElementById('username').value= 'c611821006'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementById('password').value= 'S7Nk9D9H2a'", completionHandler:  nil)
                webView.evaluateJavaScript("document.getElementsByClassName('form-element form-button')[0].click();", completionHandler:  nil)
                // Dos攻撃を防ぐ為、1度ログインに失敗したら、JavaScriptを動かすフラグを下ろす
                dataManager.canExecuteJavascript = false
                
            case .none:
                // JavaScriptを動かす必要がなかったURLの場合
                break
        }
    }
}


extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    /// セクション内のセル数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constant.initCustomCellLists.count
    }
    
    /// セルの中身
    ///
    /// - Note:
    ///  フォントサイズは17
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath)
        
        if let cell = cell as? CustomCell {
            cell.setupCell(string: Constant.initCustomCellLists[indexPath.row].title)
        }
        
        //storyboard上のセルを生成　storyboardのIdentifierで付けたものをここで設定する
//        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)

        //セル上のTag(1)とつけたUILabelを生成
//        let button = cell.contentView.viewWithTag(1) as! UIButton
//
//        //今回は簡易的にセルの番号をラベルのテキストに反映させる
//        button.setTitle(String(Constant.initCustomCellLists[indexPath.row].title), for: .normal)
//        button.tag = indexPath.row
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // タップされたセルの内容
        let cell = Constant.initCustomCellLists[indexPath.row]
        // どのセルが押されたか
        switch cell.id {
            case .syllabus:
//                self.dataManager.canExecuteJavascript = true
                let vc = R.storyboard.syllabus.syllabusViewController()!
                present(vc, animated: true, completion: nil)

            case .libraryCalendar: // 戻る
                return

            default:
                break
        }
        let vc = R.storyboard.web.webViewController()!
        vc.loadUrlString = cell.url
        present(vc, animated: true, completion: nil)
        // メニュー画面を消去後、画面を読み込む
//        self.dismiss(animated: false, completion: {
//            // ログイン処理中に別の読み込み作業が入れば処理中フラグを下ろす
//            mainVC.viewModel.isLoginProcessing = false

//        switch cell.id {
//            case .libraryCalendar: // [図書館]開館カレンダー
////                let alert = self.makeLibrarySelector(mainVC)
////                mainVC.present(alert, animated: true, completion:nil)
//
//            case .currentTermPerformance: // 今年の成績
////                if let urlRequest = self.viewModel.createCurrentTermPerformanceUrl() {
////                    mainVC.webView.load(urlRequest)
////                }else{
////                    // トーストを表示したい
////                }
//
//            case .syllabus: // シラバス
////                self.dataManager.canExecuteJavascript = true
////                let vc = R.storyboard.syllabus.syllabusViewController()!
////                vc.delegate = mainVC
////                mainVC.present(vc, animated: true, completion: nil)
//
//            case .customize: // カスタマイズ画面
////                let vc = R.storyboard.customize.customizeViewController()!
////                mainVC.present(vc, animated: true, completion: nil)
//
//            case .initPageSetting: // 初期画面の設定画面
////                let vc = R.storyboard.initPageSetting.initPageSetting()!
////                mainVC.present(vc, animated: true, completion: nil)
//
//            case .password: // パスワード設定
////                let vc = R.storyboard.password.passwordViewController()!
////                vc.delegate = mainVC
////                mainVC.present(vc, animated: true, completion: nil)
//
//            case .aboutThisApp: // このアプリについて
////                let vc = R.storyboard.aboutThisApp.aboutThisAppViewController()!
////                mainVC.present(vc, animated: true, completion: nil)
//
//            case .mailService, .tokudaiCareerCenter: // メール(Outlook), キャリアセンター
////                self.dataManager.canExecuteJavascript = true
////                let urlString = cell.url!         // fatalError(url=nilは上記で網羅できているから)
////                let url = URL(string: urlString)! // fatalError
////                mainVC.webView.load(URLRequest(url: url))
//
//            default:
////                // それ以外はURLを読み込む
////                let urlString = cell.url!         // fatalError(url=nilは上記で網羅できているから)
////                let url = URL(string: urlString)! // fatalError
////                mainVC.webView.load(URLRequest(url: url))
//        }
        // アナリティクスを送信
//        Analytics.logEvent("MenuView", parameters: ["serviceName": cell.id]) // Analytics
//        })
    }
    /// セルの高さ
    ///
    /// - Note:
    ///  表示を許可されているCellの場合、高さを44とする
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if viewModel.menuLists[indexPath.row].isDisplay {
//            return 44
//        }
//        return 0
//    }
    
    /// セルを選択時のイベント
    ///
    /// [設定]と[戻る]のセルでは、テーブルをリロードする。
    /// それ以外では画面を消した後、それぞれ処理を行う
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let mainVC = self.mainViewController else {
//            AKLog(level: .FATAL, message: "[delegateエラー]: MainViewControllerから delegate=self を渡されていない")
//            fatalError()
//        }
//        // タップされたセルの内容
//        let cell = viewModel.menuLists[indexPath[1]]
//        // どのセルが押されたか
//        switch cell.id {
//            case .setting: // 設定
//                // メニューリストを設定用リストへ更新する
//                viewModel.menuLists = Constant.initSettingLists
//                tableView.reloadData()
//                return
//
//            case .buckToMenu: // 戻る
//                // 設定用リストをメニューリストへ更新する
//                viewModel.menuLists = Constant.initMenuLists
//                tableView.reloadData()
//                return
//
//            default:
//                break
//        }
//        // メニュー画面を消去後、画面を読み込む
//        self.dismiss(animated: false, completion: {
//            // ログイン処理中に別の読み込み作業が入れば処理中フラグを下ろす
//            mainVC.viewModel.isLoginProcessing = false
//
//            switch cell.id {
//                case .libraryCalendar: // [図書館]開館カレンダー
//                    let alert = self.makeLibrarySelector(mainVC)
//                    mainVC.present(alert, animated: true, completion:nil)
//
//                case .currentTermPerformance: // 今年の成績
//                    if let urlRequest = self.viewModel.createCurrentTermPerformanceUrl() {
//                        mainVC.webView.load(urlRequest)
//                    }else{
//                        // トーストを表示したい
//                    }
//
//                case .syllabus: // シラバス
//                    self.dataManager.canExecuteJavascript = true
//                    let vc = R.storyboard.syllabus.syllabusViewController()!
//                    vc.delegate = mainVC
//                    mainVC.present(vc, animated: true, completion: nil)
//
//                case .customize: // カスタマイズ画面
//                    let vc = R.storyboard.customize.customizeViewController()!
//                    mainVC.present(vc, animated: true, completion: nil)
//
//                case .initPageSetting: // 初期画面の設定画面
//                    let vc = R.storyboard.initPageSetting.initPageSetting()!
//                    mainVC.present(vc, animated: true, completion: nil)
//
//                case .password: // パスワード設定
//                    let vc = R.storyboard.password.passwordViewController()!
//                    vc.delegate = mainVC
//                    mainVC.present(vc, animated: true, completion: nil)
//
//                case .aboutThisApp: // このアプリについて
//                    let vc = R.storyboard.aboutThisApp.aboutThisAppViewController()!
//                    mainVC.present(vc, animated: true, completion: nil)
//
//                case .mailService, .tokudaiCareerCenter: // メール(Outlook), キャリアセンター
//                    self.dataManager.canExecuteJavascript = true
//                    let urlString = cell.url!         // fatalError(url=nilは上記で網羅できているから)
//                    let url = URL(string: urlString)! // fatalError
//                    mainVC.webView.load(URLRequest(url: url))
//
//                default:
//                    // それ以外はURLを読み込む
//                    let urlString = cell.url!         // fatalError(url=nilは上記で網羅できているから)
//                    let url = URL(string: urlString)! // fatalError
//                    mainVC.webView.load(URLRequest(url: url))
//            }
//            // アナリティクスを送信
//            Analytics.logEvent("MenuView", parameters: ["serviceName": cell.id]) // Analytics
//        })
//    }
    
}
