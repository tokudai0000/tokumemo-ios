//
//  SettingViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/12/10.
//

import Foundation

final class SettingViewModel {
    
    enum SettingListItemType: Codable{
        case password                       // パスワード
        case favorite                       // お気に入り登録
        case customize                      // 並び替え
        
        case aboutThisApp                   // このアプリについて
        case contactUs                      // お問い合わせ
        case officialSNS                    // 公式SNS
        case homePage                       // ホームページ
        
        case termsOfService                 // 利用規約
        case privacyPolicy                  // プライバシーポリシー
        case sourceCode                     // ソースコード
    }
    
    struct SettingListItem {
        let title: String
        let id: SettingListItemType
        let url: String?
    }
    
    let settingLists = [[
        SettingListItem(title: "パスワード設定",
                        id: .password,
                        url: nil)
    ],[
        SettingListItem(title: "お気に入り登録",
                        id: .favorite,
                        url: nil),
        SettingListItem(title: "カスタマイズ",
                        id: .customize,
                        url: nil)
    ],[
        SettingListItem(title: "このアプリについて",
                        id: .aboutThisApp,
                        url: Url.appIntroduction.string()),
        SettingListItem(title: "お問い合わせ",
                        id: .contactUs,
                        url: Url.contactUs.string()),
        SettingListItem(title: "公式SNS",
                        id: .officialSNS,
                        url: Url.officialSNS.string()),
        SettingListItem(title: "ホームページ",
                        id: .homePage,
                        url: Url.homePage.string()),
    ],[
        SettingListItem(title: "利用規約",
                        id: .termsOfService,
                        url: Url.termsOfService.string()),
        SettingListItem(title: "プライバシーポリシー",
                        id: .privacyPolicy,
                        url: Url.privacyPolicy.string()),
        //            MenuCell(title: "ライセンス",
        //                     id: .license),
        //            MenuCell(title: "謝辞",
        //                     id: .acknowledgments),
        SettingListItem(title: "ソースコード",
                        id: .sourceCode,
                        url: Url.sourceCode.string())
    ]]
}
