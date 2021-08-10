//
//  module.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//

import UIKit

class Module: NSObject {
    let courceManagementURL = URL(string: "https://eweb.stud.tokushima-u.ac.jp/Portal") // 情報ポータルURL
    let courceManagementHomeURL = URL(string: "https://eweb.stud.tokushima-u.ac.jp/Portal/StudentApp/sp/Top.aspx") // 情報ポータル、ホーム画面URL
    let liburaryURL = URL(string: "https://opac.lib.tokushima-u.ac.jp/opac/user/top") // 図書館URL
    let manabaURL = URL(string: "https://manaba.lms.tokushima-u.ac.jp/s/home_summary") // マナバURL
    let syllabusURL = URL(string: "http://eweb.stud.tokushima-u.ac.jp/Portal/Public/Syllabus/SearchMain.aspx") // シラバスURL
    let lostConnectionUrl = URL(string : "https://localidp.ait230.tokushima-u.ac.jp/idp/profile/SAML2/Redirect/SSO?execution=e1s1") //  接続切れの際、再リロード
    
    var displayURL = URL(string: "")
    var passByValue = 0
    var hasPassdThroughOnce = false
    var hasPassdCounter = 0
    var confirmationURL = URL(string: "")
}
