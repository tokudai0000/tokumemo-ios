//
//  MainViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/10/27.
//

//WARNING// import UIKit 等UI関係は実装しない
import Foundation
import Kanna
import FirebaseAnalytics

final class MainViewModel {
    
    // Favorite画面へURLを渡すのに使用
    public var urlString = ""
    
    // シラバスをJavaScriptで自動入力する際、参照変数
    public var subjectName = ""
    public var teacherName = ""
    
    // ログイン処理中かどうか
    public var isLoginProcessing = false
    
    // 次に読み込まれるURLはJavaScriptを動かすことを許可する
    public var canExecuteJavascript = false
    
    private let dataManager = DataManager.singleton
    
    // 最新の利用規約同意者か判定し、同意画面の表示を行うべきか判定
    public var shouldShowTermsAgreementView: Bool {
        get { return dataManager.agreementVersion != Constant.latestTermsVersion }
    }
    
    /// URLの読み込みを許可するか判定
    /// ドメイン名が許可しているのと一致しているなら許可(ホワイトリスト制)
    /// - Parameter url: 判定したいURL
    /// - Returns: 判定結果、許可ならtrue
    public func isAllowedDomainCheck(_ url: URL) -> Bool {
        // ドメイン名を取得
        guard let domain = url.host else {
            AKLog(level: .ERROR, message: "[Domain取得エラー] \n url:\(url)")
            return false
        }
        // ドメインを検証
        for item in Constant.allowedDomains {
            if domain.contains(item) {
                // 一致したなら
                return true
            }
        }
        return false
    }
    
    /// JavaScriptを動かす種類
    ///
    /// - syllabus: シラバスの検索画面
    /// - loginIAS: 大学統合認証システム(IAS)のログイン画面
    /// - loginOutlook: メール(Outlook)のログイン画面
    /// - loginCareerCenter: 徳島大学キャリアセンターのログイン画面
    /// - none: JavaScriptを動かす必要がない場合
    enum JavaScriptType {
        case syllabus
        case loginIAS
        case loginOutlook
        case loginCareerCenter
        case none
    }
    /// JavaScriptを動かしたい指定のURLかどうかを判定し、動かすJavaScriptの種類を返す
    ///
    ///  以下2〜3つの状態が認められたらJavaScript実行を許可する
    ///  1. JavaScriptを実行するフラグが立っていること
    ///  2. 指定のURLであること
    ///  3. **一部**ログイン関連であれば、パスワード等を登録したユーザーであること
    ///  認められない場合は、JavaScriptを実行しない「.none」を返す
    ///  - note:
    ///    ログインに失敗した場合に再度ログインのURLが表示されることになる。
    ///    canExecuteJavascriptが存在しないと、再度ログインの為にJavaScriptが実行され続け無限ループとなってしまう。
    /// - Parameter urlString: 読み込み完了したURLの文字列
    /// - Returns: 動かすJavaScriptの種類
    public func anyJavaScriptExecute(_ urlString: String) -> JavaScriptType {
        // JavaScriptを実行するフラグが立っていない場合は抜ける
        if canExecuteJavascript == false {
            return .none
        }
        // シラバスの検索画面
        if urlString == Url.syllabus.string() {
            return .syllabus
        }
        // cアカウント、パスワードを登録しているか
        if hasRegisteredPassword == false {
            return .none
        }
        // 大学統合認証システム(IAS)のログイン画面
        if urlString.contains(Url.universityLogin.string()) {
            return .loginIAS
        }
        // メール(Outlook)のログイン画面
        if urlString.contains(Url.outlookLoginForm.string()) {
            return .loginOutlook
        }
        // 徳島大学キャリアセンターのログイン画面
        if urlString == Url.tokudaiCareerCenter.string() {
            return .loginCareerCenter
        }
        // それ以外なら
        return .none
    }

    /// 初期画面に指定したWebページのURLを返す
    ///
    /// ログイン処理完了後に呼び出される。つまり、ログインが完了したユーザーのみが呼び出す。
    /// structure Menu に存在するisInitViewがtrueであるのを探し、そのURLRequestを返す
    /// 何も設定していないユーザーはマナバ(初期値)を表示させる。
    /// - Note:
    ///   isInitViewは以下の1つの事例を除き、必ずtrueは存在する。
    ///   1. お気に入り登録内容を初期設定画面に登録し、カスタマイズから削除した場合
    /// - Returns: 設定した初期画面のURLRequest
    public func searchInitPageUrl() -> URLRequest {
        // メニューリストの内1つだけ、isInitView=trueが存在するので探す
        for menuList in dataManager.menuLists {
            // 初期画面を探す
            if menuList.isInitView {
                let urlString = menuList.url!         // fatalError **Constant.Menu(canInitView)を設定してる為、URLが存在することを保証している**
                let url = URL(string: urlString)!     // fatalError
                return URLRequest(url: url)
            }
        }
        // 見つからなかった場合
        // お気に入り画面を初期画面に設定しており、カスタマイズから削除した可能性がある為
        // マナバを表示させる
        return Url.manabaPC.urlRequest()
    }
    
    /// 大学図書館の種類
    ///
    /// - main: 常三島本館
    /// - kura: 蔵本分館
    enum LibraryType {
        case main
        case kura
    }
    /// 図書館の開館カレンダーPDFまでのURLRequestを作成する
    ///
    /// - Note:
    ///   PDFへのURLは状況により変化する為、図書館ホームページからスクレイピングを行う
    ///   例1：https://www.lib.tokushima-u.ac.jp/pub/pdf/calender/calender_main_2021.pdf
    ///   例2：https://www.lib.tokushima-u.ac.jp/pub/pdf/calender/calender_main_2021_syuusei1.pdf
    ///   ==HTML==[常三島(本館Main) , 蔵本(分館Kura)でも同様]
    ///   <body class="index">
    ///     <ul>
    ///       <li class="pos_r">
    ///         <a href="pub/pdf/calender/calender_main_2021.pdf title="開館カレンダー">
    ///   ========
    ///   aタグのhref属性を抽出、"pub/pdf/calender/"と一致していれば、例1のURLを作成する。
    /// - Parameter type: 常三島(本館Main) , 蔵本(分館Kura)のどちらの開館カレンダーを欲しいのかLibraryTypeから選択
    /// - Returns: 図書館の開館カレンダーPDFまでのURLRequest
    public func makeLibraryCalendarUrl(type: LibraryType) -> URLRequest? {
        var urlString = ""
        switch type {
            case .main:
                urlString = Url.libraryCalendarMain.string()
            case .kura:
                urlString = Url.libraryCalendarKura.string()
        }
        let url = URL(string: urlString)! // fatalError
        do {
            // URL先WebページのHTMLデータを取得
            let data = NSData(contentsOf: url as URL)! as Data
            let doc = try HTML(html: data, encoding: String.Encoding.utf8)
            // aタグ(HTMLでのリンクの出発点と到達点を指定するタグ)を抽出
            for node in doc.xpath("//a") {
                // href属性(HTMLでの目当ての資源の所在を指し示す属性)に設定されている文字列を出力
                guard let str = node["href"] else {
                    AKLog(level: .ERROR, message: "[href属性出力エラー]: href属性に設定されている文字列を出力する際のエラー")
                    return nil
                }
                // 開館カレンダーは図書ホームページのカレンダーボタンにPDFへのURLが埋め込まれている
                if str.contains("pub/pdf/calender/") {
                    // PDFまでのURLを作成する(本館のURLに付け加える)
                    let pdfUrlString = Url.libraryHomePageMainPC.string() + str
                    
                    if let url = URL(string: pdfUrlString) {
                        return URLRequest(url: url)
                    } else {
                        AKLog(level: .ERROR, message: "[URLフォーマットエラー]: 図書館開館カレンダーURL取得エラー \n pdfUrlString:\(pdfUrlString)")
                        return nil
                    }
                }
            }
            AKLog(level: .ERROR, message: "[URL抽出エラー]: 図書館開館カレンダーURLの抽出エラー \n urlString:\(url.absoluteString)")
        } catch {
            AKLog(level: .ERROR, message: "[Data取得エラー]: 図書館開館カレンダーHTMLデータパースエラー\n urlString:\(url.absoluteString)")
        }
        return nil
    }
    
    /// 大学統合認証システム(IAS)へのログインが完了したかどうか
    ///
    /// 以下2つの状態が認められたら完了とする
    ///  1. ログイン後のURLが指定したURLと一致していること
    ///  2. ログイン処理中であるフラグが立っていること
    ///  認められない場合は、falseとする
    /// - Parameter urlString: 現在表示しているURLString
    /// - Returns: 判定結果、許可ならtrue
    public func isLoggedin(_ urlString: String) -> Bool {
        // ログイン後のURLが指定したURLと一致しているかどうか
        let check1 = urlString.contains(Url.enqueteReminder.string())
        let check2 = urlString.contains(Url.courseManagementPC.string())
        let check3 = urlString.contains(Url.courseManagementMobile.string())
        // 上記から1つでもtrueがあれば、引き継ぐ
        let result = check1 || check2 || check3
        // ログイン処理中かつ、ログインURLと異なっている場合(URLが同じ場合はログイン失敗した状態)
        if isLoginProcessing && result {
            // ログイン処理を完了とする
            isLoginProcessing = false
            return true
        }
        return false
    }
    
    /// 現在の時刻を保存する
    public func saveCurrentTime() {
        // 現在の時刻を取得し保存
        let f = DateFormatter()
        f.setTemplate(.full)
        let now = Date()
        dataManager.saveTimeUsedLastTime = f.string(from: now)
    }
    
    /// 再度ログイン処理を行うかどうか
    ///
    /// - Returns: 判定結果、行うべきならtrue
    public func isExecuteLogin() -> Bool {
        // dataManagerのsaveCurrentTime(String型)をDateに変換する
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "MM/dd/yyyy, HH:mm:ss"
        if let lastTime = formatter.date(from: dataManager.saveTimeUsedLastTime) {
            // 現在の時刻を取得
            let f = DateFormatter()
            f.setTemplate(.time)
            let now = Date()
            // 時刻の差分が30*60分以上であれば再ログインを行う
            if now.timeIntervalSince(lastTime) > 30 * 60 {
                return true
            }
        }
        return false
    }
    
    /// タイムアウトのURLであるかどうかの判定
    /// - Parameter urlString: 読み込み完了したURLの文字列
    /// - Returns: 結果
    public func isTimeout(_ urlString: String) -> Bool {
        if urlString == Url.universityServiceTimeOut.string() ||
            urlString == Url.universityServiceTimeOut2.string() {
            return true
        }
        return false
    }
    
    /// FireBaseアナリティクスを送信する
    /// - Parameter urlString: 読み込まれたURLの文字列
    public func analytics(_ urlString: String) {
        // Analytics
        Analytics.logEvent("WebViewReload", parameters: ["pages": urlString])
    }
    
    // MARK: - Private
    // cアカウント、パスワードを登録しているか判定
    private var hasRegisteredPassword: Bool { get { return (!dataManager.cAccount.isEmpty && !dataManager.password.isEmpty) }}
}
