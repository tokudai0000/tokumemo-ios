//
//  module.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit

class Module: NSObject {
    
    /// 情報ポータルURL
    let courceManagementURL = URL(string: "https://eweb.stud.tokushima-u.ac.jp/Portal")
    /// 情報ポータル、ホーム画面URL
    let courceManagementHomeURL = URL(string: "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/sp/Top.aspx")
    /// 図書館URL
    let liburaryURL = URL(string: "https://opac.lib.tokushima-u.ac.jp/opac/user/top")
    /// マナバURL
    let manabaURL = URL(string: "https://manaba.lms.tokushima-u.ac.jp/s/home_summary")
    /// シラバスURL
    let syllabusURL = URL(string: "http://eweb.stud.tokushima-u.ac.jp/Portal/Public/Syllabus/SearchMain.aspx")
    /// 接続切れの際、再リロード
    let lostConnectionUrl = URL(string : "https://localidp.ait230.tokushima-u.ac.jp/idp/profile/SAML2/Redirect/SSO?execution=e1s1")
    
    /// 現在表示しているURLを保持
    var displayURL = URL(string: "")
    /// 確認用のURLを保持
    var confirmationURL = URL(string: "")
    
    /// 回数を保持
    var hasPassdThroughOnce = false
    var hasPassdCounter = 0
}
