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
    
    /// 登録者か判定
    public func isRegistrantCheck() -> Bool {
        if (DataManager.singleton.cAccount != "" &&
            DataManager.singleton.password != "") {
            return true

        }
        return false
    }
    
    /// 教務事務システム、マナバのMobileかPCか判定
    public func isDisplayUrlForPC() -> (String?, URLRequest) {
                
        switch dataManager.displayUrl {
        // 教務事務システムMobile版
        case UrlModel.courceManagementHomeMobile.string():
            dataManager.setCorceManagement(word: "PC")
            return (R.image.pcIcon.name, UrlModel.courceManagementHomePC.urlRequest())

        // 教務事務システムPC版
        case UrlModel.courceManagementHomePC.string():
            dataManager.setCorceManagement(word: "Mobile")
            return (R.image.pcIcon.name, UrlModel.courceManagementHomeMobile.urlRequest())

        // Manaba Mobile版
        case UrlModel.manabaHomeMobile.string():
            dataManager.setManabaId(word: "PC")
            return (R.image.mobileIcon.name, UrlModel.manabaHomePC.urlRequest())

        // Manaba PC版
        case UrlModel.manabaHomePC.string():
            dataManager.setManabaId(word: "Mobile")
            return (R.image.pcIcon.name, UrlModel.manabaHomeMobile.urlRequest())


        default:
            return ("No Image", UrlModel.systemServiceList.urlRequest())
        }
    }
    
    /// タブバーの判定
    public func tabBarDetection(num: Int) -> NSURLRequest? {
        
        if isRegistrantCheck() {
            switch num {
            case 1: // 左
                if dataManager.getCorceManagement() == "PC" {
                    return webViewModel.url(.courceManagementHomePC)
                    
                } else {
                    return webViewModel.url(.courceManagementHomeSP)
                    
                }
                
                
            case 2: // 右
                if dataManager.getManaba() == "PC" {
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
