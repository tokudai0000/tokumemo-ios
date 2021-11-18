//
//  MainViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/10/27.
//

import Foundation

final class MainViewModel: NSObject {
    
    //MARK: - STATE ステータス
    enum State {
        case busy           // 準備中
        case ready          // 準備完了
        case error          // エラー発生
    }
    public var state: ((State) -> Void)?
    
    
    enum NextView {
        case syllabus           // 準備中
        case password
        case aboutThisApp
    }
    public var next: ((NextView) -> Void)?
    
    
    private let model = Model()
    private let dataManager = DataManager.singleton
    private let webViewModel = WebViewModel()
    
    private var requestUrl: NSURLRequest?
    
    public var imageSystemName = "chevron.down"
    public var animationView = ""
    
    public var syllabusSubjectName = ""
    public var syllabusTeacherName = ""
    

    // MARK: - Public
    
//    enum PcOrMobile {
//        case pc
//        case mobile
//    }
//    enum CourceManagementManaba {
//        case courceManagement
//        case manaba
//    }
    enum CourceManagementManabaPcOrMobile {
        case courceManagementPC
        case courceManagementMobile
        case manabaPC
        case manabaMobile
    }
    
    /// 教務事務システム、マナバのMobileかPCか判定
    public func isCourceManagementUrlForPC(displayUrl: String) -> CourceManagementManabaPcOrMobile {
        switch displayUrl {
        case Url.courceManagementHomeMobile.string():  return .courceManagementPC
        case Url.courceManagementHomePC.string():      return .courceManagementMobile
        case Url.manabaHomeMobile.string():            return .manabaPC
        case Url.manabaHomePC.string():                return .manabaMobile

        default:
            fatalError()
        }
    }
    
    enum TabBarItem: Int {
        case courceManagement = 1
        case manaba = 2
    }
    /// タブバーの判定
    public func tabBarDetection(num: Int) -> NSURLRequest? {
        let tabBarItem = TabBarItem(rawValue: num)
        
        switch TabBarItem(rawValue: num) {
            
        case .none:
            <#code#>
        case .some(_):
            <#code#>
        }
        
        if dataManager.isRegistrantCheck {
            switch tabBarItem {
            case .courceManagement: // 左
                if dataManager.courceManagement == "PC" {
                    return webViewModel.url(.courceManagementHomePC)
                    
                } else {
                    return webViewModel.url(.courceManagementHomeSP)
                    
                }
                
                
            case .manaba: // 右
                if dataManager.manaba == "PC" {
                    return webViewModel.url(.manabaPC)
                    
                } else {
                    return webViewModel.url(.manabaSP)

                }
                
            default:
                return nil
            }
        } else {
            switch tabBarItem {
            case .courceManagement: // 左
                return webViewModel.url(.systemServiceList)
                
                
            case .manaba: // 右
                return webViewModel.url(.eLearningList)
                
                
            default:
                return nil
            }
        }
        
    }
    
    // num も.right . leftにしたい
    public func tabBarDetection(num: Int, isRegist: Bool) -> NSURLRequest? {
        if isRegist {
            switch num {
            case 1: // 左
//                return aaa
//                func aaa() {
                    if dataManager.courceManagement == "PC" {
                        return webViewModel.url(.courceManagementHomePC)
                    } else {
                        return webViewModel.url(.courceManagementHomeSP)
                    }
                
                
            case 2: // 右
                if dataManager.manaba == "PC" {
                    return webViewModel.url(.manabaPC)
                } else {
                    return webViewModel.url(.manabaSP)
                }
                
            default:
                return nil
            }
            
        } else {
            switch num {
            case 1: // 左
                return webViewModel.url(.systemServiceList)
                
            case 2: // 右
                return webViewModel.url(.eLearningList)
                
            default:
                return nil
            }
        }
    }
    
    
    enum ViewOperation {
        case up
        case down
        case reverse
    }
    
    enum AnimeOperation {
        case launchScreen
        case viewUp
        case viewDown
        case Nil
    }
   
    /// WebViewの上げ下げを判定
    public func viewPosisionType(_ operation: ViewOperation, posisionY: Double) -> (imageName: String?, animationName: AnimeOperation) {
        
        switch operation {
        case .up:
            // Viewを動かして良いのか判定
            if (0.0 < posisionY) {
                // Viewを上げた後、[chevron.down]のImageに差し替える
                return ("chevron.down", .viewUp)
            }
            
        case .down:
            if (posisionY <= 0.0) {
                return ("chevron.up", .viewDown)
            }
            
        case .reverse:
            if (posisionY <= 0.0) {
                return ("chevron.up", .viewDown)
                
            } else {
                return ("chevron.down", .viewUp)
            }
        }
        return (nil, .Nil)

    }
    
    
    // MARK: - Private
    
    
}
