//
//  SettingViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/12/10.
//

//WARNING// import UIKit 等UI関係は実装しない
import Foundation

final class SettingViewModel {
    
    enum SettingItemType {
        
        case password
        
        /// お気に入り登録
        case favorite
        
        /// 並び替え機能
        case customize
        
        case aboutThisApp
        
        case contactUs
        
        /// トクメモ＋のTwitter
        case officialSNS
        
        /// トクメモ＋のLit.linkホームページ
        case homePage
        
        case termsOfService
        
        case privacyPolicy
        
        /// univIPのGitHub
        case sourceCode
    }
    
    struct SettingItem {
        let title: String
        let id: SettingItemType
        let url: String?
    }
    
    let settingItemLists = [
        [SettingItem(title: "パスワード設定", id: .password, url: nil)],
        
        [SettingItem(title: "お気に入り登録", id: .favorite, url: nil),
         SettingItem(title: "カスタマイズ", id: .customize, url: nil)],
        
        [SettingItem(title: "このアプリについて", id: .aboutThisApp, url: Url.appIntroduction.string()),
         SettingItem(title: "お問い合わせ", id: .contactUs, url: Url.contactUs.string()),
         SettingItem(title: "公式SNS", id: .officialSNS, url: Url.officialSNS.string()),
         SettingItem(title: "ホームページ", id: .homePage, url: Url.homePage.string()),],
        
        [SettingItem(title: "利用規約", id: .termsOfService, url: Url.termsOfService.string()),
         SettingItem(title: "プライバシーポリシー", id: .privacyPolicy, url: Url.privacyPolicy.string()),
         SettingItem(title: "ソースコード", id: .sourceCode,url: Url.sourceCode.string())]]
}
