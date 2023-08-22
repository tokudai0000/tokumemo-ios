//
//  Url.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/11/03.
//

import Foundation

enum Url: String {
    /// 何もリクエストしない(エラー用)
    case emptyRequest = "about:blank"
    /// 大学ホームページ
    case universityHomePage = "https://www.tokushima-u.ac.jp/"
    /// 統合認証システム
    case portal = "https://my.ait.tokushima-u.ac.jp/portal/"
    /// Eラーニング一覧
    case eLearningList = "https://uls01.ulc.tokushima-u.ac.jp/info/index.html"
    
    /// 教務システム(PC)
    case courseManagementPC = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Top.aspx"
    /// 教務事務システム(Mobile)
    case courseManagementMobile  = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/sp/Top.aspx"
    /// マナバ(PC)
    case manabaPC = "https://manaba.lms.tokushima-u.ac.jp/ct/home"
    /// マナバ(Mobile)
    case manabaMobile = "https://manaba.lms.tokushima-u.ac.jp/s/home_summary"
    
    /// 講義時間割 旧:https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Regist/RegistList.aspx
    case timeTable = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Sp/Schedule/Day.aspx"
    /// 今期の成績表
    case currentTermPerformance = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Sp/ReferResults/SubDetail/Results_Get_YearTerm.aspx"
    /// 成績選択画面
    case termPerformance = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/ReferResults/Menu.aspx"
    /// 出欠記録
    case presenceAbsenceRecord = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Attendance/AttendList.aspx"
    /// 授業評価アンケート
    case classQuestionnaire = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Enquete/EnqAnswerList.aspx"
    /// 履修登録
    case courseRegistration = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Regist/RegistEdit.aspx"

    /// スーパー英語
    case superEnglishLogin = "https://tse.ait231.tokushima-u.ac.jp/student/main/login/"
    
    /// 図書館サイト(本館PC)
    case libraryHomePageMainPC = "https://www.lib.tokushima-u.ac.jp/"
    /// 図書館サイト(蔵本PC)
    case libraryHomePageKuraPC = "https://www.lib.tokushima-u.ac.jp/kura.shtml"
    /// 図書館サイト(Mobile)
    case libraryHomeMobile = "https://opac.lib.tokushima-u.ac.jp/drupal/"
    /// MyPage
    case libraryMyPage = "https://opac.lib.tokushima-u.ac.jp/opac/user/top"
    /// 本貸出し期間延長
    case libraryBookLendingExtension = "https://opac.lib.tokushima-u.ac.jp/opac/user/holding-borrowings"
    /// 本購入リクエスト
    case libraryBookPurchaseRequest = "https://opac.lib.tokushima-u.ac.jp/opac/user/purchase_requests/new"
    
    /// outlook(メール)複数回遷移したのち、outlookLoginFormへ行く
    case outlookService = "https://outlook.office365.com/tokushima-u.ac.jp"
    /// ログイン画面
    case outlookLoginForm = "https://wa.tokushima-u.ac.jp/adfs/ls"
    
    /// シラバス
    case syllabus = "http://eweb.stud.tokushima-u.ac.jp/Portal/Public/Syllabus/"
    
    /// 検索完了後のシラバス
    case syllabusSearchCompleted = "http://eweb.stud.tokushima-u.ac.jp/Portal/Public/Syllabus/SearchMain.aspx"
    
    /// 徳島大学キャリアセンター
    case tokudaiCareerCenter = "https://www.tokudai-syusyoku.com/index.php"
    
    /// 徳島大学生活共同組合　旧"https://tokudai.marucoop.com/#parts"
    case tokudaiCoop = "https://vsign.jp/tokudai/maruco#parts"
    
    /// 徳島大学生協食堂メニュー
    case tokudaiCoopDinigMenu = "https://tokudaicoop.jp/food2.html"
    
    /// 学びサポート企画部
    case studySupportSpace = "https://www.lib.tokushima-u.ac.jp/support/sss/index.html"
    
    /// 防災情報
    case disasterPrevention = "https://www.tokushima-u.ac.jp/rcmode/business/46584.html"
    
    /// ログイン画面に遷移する為のURL(何度もURL遷移を行う) 旧http://eweb.stud.tokushima-u.ac.jp/Portal/top.html
    case universityTransitionLogin = "http://eweb.stud.tokushima-u.ac.jp/Portal/top.html"
    /// 大学サイト、ログイン画面
    case universityLogin = "https://localidp.ait230.tokushima-u.ac.jp/idp/profile/SAML2/Redirect/SSO?execution="
    /// タイムアウト(20分無操作)
    case universityServiceTimeOut = "https://eweb.stud.tokushima-u.ac.jp/Portal/RichTimeOut.aspx"
    /// タイムアウト2(20分無操作)
    case universityServiceTimeOut2 = "https://eweb.stud.tokushima-u.ac.jp/Portal/RichTimeOutSub.aspx"
    /// アンケート催促画面(教務事務表示前に出現)
    case skipReminder = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/TopEnqCheck.aspx"
    /// マナバから授業動画[Youtube]を開く時
    case popupToYoutube = "https://manaba.lms.tokushima-u.ac.jp/s/link_balloon"
    /// GoogleFormsでPR画像申請フォームを作成
    case prApplication = "https://docs.google.com/forms/d/e/1FAIpQLSeyQ-rpMslvLp4WSLc1JsyI9skve_WYYNp61G1zlRAdGKVlBQ/viewform"
    /// GoogleFormsでお問い合わせフォームを作成
    case contactUs = "https://docs.google.com/forms/d/e/1FAIpQLScYRhlWY9IjqWOrvnWJ0bJ_yPQZpXy4PPShWb68092t2klzeg/viewform"
    /// TwitterのURL
    case officialSNS = "https://twitter.com/tokumemo0000"
    /// ホームページのURL
    case homePage = "https://lit.link/developers"
    /// トクメモ＋のプライバシーポリシーURL[GitHub]
    case privacyPolicy = "https://tokudai0000.github.io/tokumemo_resource/document/privacy_policy.txt"
    /// トクメモ＋の利用規約URL[GitHub]
    case termsOfService = "https://tokudai0000.github.io/tokumemo_resource/document/terms_of_service.txt"
    /// アプリ紹介文
    case appIntroduction = "https://tokudai0000.github.io/tokumemo_resource/document/tokumemo_explanation.txt"
    /// トクメモ＋のソースコード[GitHub]
    case sourceCode = "https://github.com/tokudai0000/univIP"
    /// トクメモ＋のソースコード[GitHub]
    case github = "https://github.com/tokudai0000"
    /// 気象庁の天気予報
    case weather = "https://www.jma.go.jp/bosai/#area_type=class20s&area_code=3620100&pattern=forecast"
    
    /// 徳大学生活動リスト
    case clubLists = "https://tokudai0000.github.io/club-list/"
    
    
    case prItemJsonData = "https://tokudai0000.github.io/tokumemo_resource/pr_image/info.json"
    
    case weatherItemJsonData = "https://api.openweathermap.org/data/2.5/weather"
    
    case newsItemJsonData = "https://api.rss2json.com/v1/api.json?rss_url=https://www.tokushima-u.ac.jp/recent/rss.xml"
    
    /// URLを文字列として返す
    func string() -> String {
        return rawValue
    }
    
    /// URLをURLRequestとして返す
    func urlRequest() -> URLRequest {
        let urlString = rawValue
        let url = URL(string: urlString)! // fatalError
        return URLRequest(url: url)
    }
}
