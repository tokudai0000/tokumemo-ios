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
    
    enum ViewMoveIcon {
        case up
        case down
    }
    
    enum ViewMoveType {
        case headerIsHidden
        case headerIsShow
        case headerIsReverse
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

}
