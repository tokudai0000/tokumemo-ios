//
//  FirstViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/03/02.
//

//WARNING// import UIKit 等UI関係は実装しない
import Foundation

final class InitPageSettingModel {
    /// ピッカーリストの内容
    ///
    /// 初期設定に登録することができるリストを表示させる
    /// 参照するたびに、メニューリストからcanInitView=trueだけを追加して表示する
    public var pickerList: [Constant.Menu] = []
    init() {
        for item in dataManager.menuLists {
            // 初期画面に許可しているCellを表示する配列に追加
            if item.canInitView {
                pickerList.append(item)
            }
        }
    }
    
    private let dataManager = DataManager.singleton
    
    /// 現在設定している初期画面を探す
    /// - Returns: 初期画面のタイトルを返す
    public func searchTitleCell() -> String {
        for item in dataManager.menuLists {
            // 現在設定している初期画面を表示
            if item.isInitView {
                return item.title
            }
        }
        return ""
    }
    
    /// 初期画面の設定を更新する
    /// - Parameter pickerType: 初期画面に設定したいメニューID
    public func saveInitPage(_ pickerType: Constant.MenuLists) {
        var menuLists = dataManager.menuLists
        for i in 0..<menuLists.count {
            // 選択された内容とインデックス番号を照合
            let result = (menuLists[i].id == pickerType)
            menuLists[i].isInitView = result
        }
        dataManager.menuLists = menuLists
        // menuListsをUserDefaultsに保存
        dataManager.saveMenuLists()
    }
}
