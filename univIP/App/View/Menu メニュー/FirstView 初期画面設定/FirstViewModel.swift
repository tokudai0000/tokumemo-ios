//
//  FirstViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/03/02.
//

//WARNING// import UIKit 等UI関係は実装しない
import Foundation

final class FirstViewModel {
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
}
