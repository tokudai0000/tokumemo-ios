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
    private let webViewModel = WebViewModel()
    private let dataManager = DataManager.singleton
    
    
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
    
    enum AnimeOperation {
        case launchScreen
        case moveUp
        case moveDown
    }
    
    enum ViewMoveIcon {
        case up
        case down
    }
    
    enum ViewMoveType {
        case moveUp
        case moveDown
        case moveReverse
    }
    
    
    // MARK: - Public
    
    /// タブバーの判定
    public func tabBarDetection(tabBarRowValue: Int,
                                isRegist: Bool,
                                courceType: String,
                                manabaType: String) -> URLRequest?
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
    
    public func webViewChangeButtonImage(displayUrl: String) -> String? {
        switch displayUrl {
        case Url.courceManagementHomeMobile.string():  return R.image.pcIcon.name
        case Url.courceManagementHomePC.string():      return R.image.mobileIcon.name
        case Url.manabaHomeMobile.string():            return R.image.pcIcon.name
        case Url.manabaHomePC.string():                return R.image.mobileIcon.name

        default:                                       return nil
        }
    }
    
    public func webViewChangeUrl(displayUrl: String) -> URLRequest? {
        switch displayUrl {
        case Url.courceManagementHomeMobile.string():  return Url.courceManagementHomeMobile.urlRequest()
        case Url.courceManagementHomePC.string():      return Url.courceManagementHomePC.urlRequest()
        case Url.manabaHomeMobile.string():            return Url.manabaHomeMobile.urlRequest()
        case Url.manabaHomePC.string():                return Url.manabaHomePC.urlRequest()

        default:                                       return nil
        }
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
