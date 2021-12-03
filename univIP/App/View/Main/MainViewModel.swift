//
//  MainViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/10/27.
//

import Foundation

// MARK: - Question NSObjectなし
final class MainViewModel: NSObject {
    
    private let model = Model()
    private let dataManager = DataManager.singleton
    private let webViewModel = WebViewModel()
    
    
    enum NextModalView {
        case syllabus
        case password
        case aboutThisApp
    }
    
    enum CourceManagementManabaPcOrMobile {
        case courceManagementPC
        case courceManagementMobile
        case manabaPC
        case manabaMobile
    }
    
    enum TabBarItem: Int {
        case courceManagement = 1
        case manaba = 2
    }
    
    enum ViewOperation {
        case up
        case down
        case reverse
    }
    
    enum AnimeOperation {
        case launchScreen
        case moveUp
        case moveDown
    }
    
    enum ViewMoveIcon: String {
        case up = "chevron.up"
        case down = "chevron.down"
    }
    
    
    // MARK: - Public
    /// 教務事務システム、マナバのMobileかPCか判定
    public func isCourceManagementUrlForPC(displayUrl: String) -> CourceManagementManabaPcOrMobile
    {
        switch displayUrl {
        case Url.courceManagementHomeMobile.string():  return .courceManagementPC
        case Url.courceManagementHomePC.string():      return .courceManagementMobile
        case Url.manabaHomeMobile.string():            return .manabaPC
        case Url.manabaHomePC.string():                return .manabaMobile

        default:
            fatalError()
        }
    }
    
    /// タブバーの判定
    public func tabBarDetection(tabBarRowValue: Int,
                                isRegist: Bool,
                                courceType: String,
                                manabaType: String) -> NSURLRequest?
    {
        let tabBarItem = TabBarItem(rawValue: tabBarRowValue)!
        
        switch tabBarItem {
        case .courceManagement:
            if isRegist {
                if courceType == "PC" {
                    return webViewModel.url(.courceManagementHomePC)
                } else {
                    return webViewModel.url(.courceManagementHomeSP)
                }
                
            } else {
                return webViewModel.url(.systemServiceList)
            }
            
        case .manaba:
            if isRegist {
                if manabaType == "PC" {
                    return webViewModel.url(.manabaPC)
                } else {
                    return webViewModel.url(.manabaSP)
                }
                
            } else {
                return webViewModel.url(.eLearningList)
            }
        }
    }
    
    enum ViewMoveType {
        case moveUp
        case moveDown
        case moveReverse
    }
    
    /// WebViewの上げ下げを判定
    public func viewVerticallyMoveButtonImage(_ operation: ViewMoveType,
                                              posisionY: Double) -> String?
    {
        let up = "chevron.up"
        let down = "chevron.down"
        
        switch operation {
        case .moveUp: // Viewを上げたい場合
            if (0.0 < posisionY) { // Viewを動かして良いのか判定
                return down
            }
            
        case .moveDown: // Viewを下げたい場合
            if (posisionY <= 0.0) { // 下げる前のViewのポジション
                return up
            }
            
        case .moveReverse:
            if posisionY <= 0.0 {
                return up
            } else {
                return down
            }
        }
        return nil
    }
    
    public func viewVerticallyMoveAnimation(_ operation: ViewMoveType,
                                            posisionY: Double) -> AnimeOperation?
    {
        switch operation {
        case .moveUp: // Viewを上げたい場合
            if (0.0 < posisionY) { // Viewを動かして良いのか判定
                return .moveUp
            }
            
        case .moveDown: // Viewを下げたい場合
            if (posisionY <= 0.0) { // 下げる前のViewのポジション
                return .moveDown
            }
            
        case .moveReverse:
            if !(posisionY <= 0.0) {
                return .moveUp
            } else {
                return .moveDown
            }
        }
        return nil
    }
        
}
