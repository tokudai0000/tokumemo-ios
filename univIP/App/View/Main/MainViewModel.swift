//
//  MainViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/10/27.
//

import Foundation

final class MainViewModel: NSObject {
    
    private let model = Model()
    private let urlModel = UrlModel()
    private let webViewModel = WebViewModel()
    private var requestUrl: NSURLRequest?
    
    public var imageSystemName = ""
    public var animationView = ""
    
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
        case contactToDeveloper
    }
    public var next: ((NextView) -> Void)?

    
    public func isDisplayUrlForPC() -> String { // boolにしたい
        
        switch webViewModel.displayUrl {
        case urlModel.courceManagementHomeSP:
            UserDefaults.standard.set("pc", forKey: "CMPCtoSP")
            return R.image.spIcon.name
            
            
        case urlModel.courceManagementHomePC:
            UserDefaults.standard.set("sp", forKey: "CMPCtoSP")
            return R.image.pcIcon.name
            
            
        case urlModel.manabaSP:
            UserDefaults.standard.set("pc", forKey: "ManabaPCtoSP")
            return R.image.spIcon.name
            
            
        case urlModel.manabaPC:
            UserDefaults.standard.set("sp", forKey: "ManabaPCtoSP")
            return R.image.pcIcon.name
            
            
        default:
            return "No Image"
        }
    }
    
    
    public func tabBarDetection(num: Int) -> NSURLRequest? {
//        if passedCertification {
//            
//        }
        
        switch num {
        case 1: // 左
            if UserDefaults.standard.string(forKey: "CMPCtoSP") == "pc" {
                return webViewModel.url(.courceManagementHomePC)
                
            }else{
                return webViewModel.url(.courceManagementHomeSP)
                
            }
            
            
        case 2: // 右
            if UserDefaults.standard.string(forKey: "ManabaPCtoSP") == "pc"{
                return webViewModel.url(.manabaPC)
                
            }else{
                return webViewModel.url(.manabaSP)

            }
            
        default:
            return nil
        }
    }
    
        
    func viewPosisionType(posisionY: Double) {
        
        switch posisionY {
        case 0.0:
            imageSystemName = "chevron.up"
            animationView = "rightButtonUp"

            
        default:
            imageSystemName = "chevron.down"
            animationView = "rightButtonDown"
        }
    }
    
}
