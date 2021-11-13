//
//  MainViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/10/27.
//

import Foundation
import UIKit

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
    private let webViewModel = WebViewModel.singleton // WebViewModel()
    
    private var requestUrl: NSURLRequest?
    private let KEY_corceManagementId = "KEY_corceManagementId"
    private let KEY_manabaId = "KEY_manabaId"
    
    public var imageSystemName = "chevron.down"
    public var animationView = ""
    

    // MARK: - Public
    
    /// 教務事務システム、マナバのMobileかPCか判定
    public func isDisplayUrlForPC() -> (UIImage?, URLRequest) {
                
        switch dataManager.displayUrl {
        // 教務事務システムMobile版
        case UrlModel.courceManagementHomeMobile.string():
            UserDefaults.standard.set("pc", forKey: KEY_corceManagementId)
            return (UIImage(named: R.image.pcIcon.name), UrlModel.courceManagementHomePC.urlRequest())

        // 教務事務システムPC版
        case UrlModel.courceManagementHomePC.string():
            UserDefaults.standard.set("mobile", forKey: KEY_corceManagementId)
            return (UIImage(named: R.image.pcIcon.name), UrlModel.courceManagementHomeMobile.urlRequest())

        // Manaba Mobile版
        case UrlModel.manabaHomeMobile.string():
            UserDefaults.standard.set("pc", forKey: KEY_manabaId)
            return (UIImage(named: R.image.spIcon.name), UrlModel.manabaHomePC.urlRequest())

        // Manaba PC版
        case UrlModel.manabaHomePC.string():
            UserDefaults.standard.set("mobile", forKey: KEY_manabaId)
            return (UIImage(named: R.image.pcIcon.name), UrlModel.manabaHomeMobile.urlRequest())


        default:
            return (UIImage(named: "No Image"), UrlModel.systemServiceList.urlRequest())
        }
    }
    
    /// タブバーの判定
    public func tabBarDetection(num: Int) -> NSURLRequest? {
        
        if webViewModel.isRegistrantCheck() {
            switch num {
            case 1: // 左
                if UserDefaults.standard.string(forKey: KEY_corceManagementId) == "pc" {
                    return webViewModel.url(.courceManagementHomePC)
                    
                } else {
                    return webViewModel.url(.courceManagementHomeSP)
                    
                }
                
                
            case 2: // 右
                if UserDefaults.standard.string(forKey: KEY_manabaId) == "pc"{
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
    
    /// WebViewの上げ下げを判定
    public func viewPosisionType(operation: String, posisionY: Double) {
        
        var ope = ""
        switch operation {
        case "UP":
            if (posisionY != 0.0){
                ope = "UP"
            }
            
        case "DOWN":
            if (posisionY == 0.0){
                ope = "DOWN"
            }
            
        case "REVERSE":
            if (posisionY == 0.0){
                ope = "DOWN"
            } else {
                ope = "UP"
            }
        default:
            return
        }
        
        switch ope {
        case "UP":
            imageSystemName = "chevron.down"
            animationView = "rightButtonDown"
            return
        case "DOWN":
            imageSystemName = "chevron.up"
            animationView = "rightButtonUp"
            return
        default:
            animationView = ""
            return
        }

    }
    
    /// 教務事務システム、マナバのMobileかPCか判定
    public func isDisplayCourceManagementOrManaba() -> Bool {
                
        switch dataManager.displayUrl {
        // 教務事務システムMobile版
        case UrlModel.courceManagementHomeMobile.string():
            return true

        // 教務事務システムPC版
        case UrlModel.courceManagementHomePC.string():
            return true

        // Manaba Mobile版
        case UrlModel.manabaHomeMobile.string():
            return true

        // Manaba PC版
        case UrlModel.manabaHomePC.string():
            return true


        default:
            return false
        }
    }
    
    // MARK: - Private
    
    
}
