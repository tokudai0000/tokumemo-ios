//
//  UrlModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/11/03.
//

import Foundation

enum Url: String {
    /// 大学ホームページ
    case universityHomePage = "https://www.tokushima-u.ac.jp/"
    /// システムサービス一覧
    case systemServiceList = "https://www.ait.tokushima-u.ac.jp/service/list_out/"
    /// Eラーニング一覧
    case eLearningList = "https://uls01.ulc.tokushima-u.ac.jp/info/index.html"
    
    /// 教務事務システム(PC)
    case courseManagementPC = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Top.aspx"
    /// 教務事務システム(Mobile)
    case courseManagementMobile  = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/sp/Top.aspx"
    /// マナバ(PC)
    case manabaPC = "https://manaba.lms.tokushima-u.ac.jp/ct/home"
    /// マナバ(Mobile)
    case manabaMobile = "https://manaba.lms.tokushima-u.ac.jp/s/home_summary"
    
    /// 講義時間割
    case timeTable = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Regist/RegistList.aspx"
    /// 今期の成績表
    case currentTermPerformance = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Sp/ReferResults/SubDetail/Results_Get_YearTerm.aspx?year="
    /// 成績選択画面
    case termPerformance = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/ReferResults/Menu.aspx"
    /// 出欠記録
    case presenceAbsenceRecord = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Attendance/AttendList.aspx"
    /// 授業評価アンケート
    case classQuestionnaire = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Enquete/EnqAnswerList.aspx"
    /// 履修登録
    case courseRegistration = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/Regist/RegistEdit.aspx"
    
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
    
    /// 徳島大学キャリアセンター
    case tokudaiCareerCenter = "https://www.tokudai-syusyoku.com/index.php"
    
    /// 徳島大学生活共同組合
    case tokudaiCoop = "https://tokudai.marucoop.com/#parts"
    
    /// ログイン画面に遷移する為のURL(何度もURL遷移を行う)
    case universityTransitionLogin = "http://eweb.stud.tokushima-u.ac.jp/Portal/top.html"
    /// 大学サイト、ログイン画面
    case universityLogin = "https://localidp.ait230.tokushima-u.ac.jp/idp/profile/SAML2/Redirect/SSO?execution="
    /// タイムアウト(20分無操作)
    case universityServiceTimeOut = "https://eweb.stud.tokushima-u.ac.jp/Portal/RichTimeOut.aspx"
    /// タイムアウト2(20分無操作)
    case universityServiceTimeOut2 = "https://eweb.stud.tokushima-u.ac.jp/Portal/RichTimeOutSub.aspx"
    /// アンケート催促画面(教務事務表示前に出現)
    case questionnaireReminder = "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/TopEnqCheck.aspx"
    /// マナバから授業動画[Youtube]を開く時
    case popupToYoutube = "https://manaba.lms.tokushima-u.ac.jp/s/link_balloon"
    
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
