//
//  BaseViewModel.swift
//  ViewModelに共通機能を提供する
//
//  Created by Akihiro Matsuyama on 2022/11/18.
//
//WARNING// import UIKit 等UI関係は実装しない
import Foundation

///
protocol BaseViewModelProtocol {
    /// ViewModel.State：ViewModelに変化があったことをViewに知らせる（受け取ったViewはViewModelで画面を更新する）
    associatedtype State
    var state: ((State) -> Void)? { get set }
}
///
class BaseViewModel: NSObject {
    // 共通データ・マネージャ
    public let dataManager = DataManager.singleton
    // API マネージャ
    public let apiManager = ApiManager.singleton
}


