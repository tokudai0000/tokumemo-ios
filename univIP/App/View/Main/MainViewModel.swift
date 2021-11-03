//
//  MainViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/10/27.
//

import Foundation

final class MainViewModel: NSObject {
    class WebViewOperation {
        var cAcount: String = ""
        var password: String = ""
        
        func login() {
            
        }
        
//        init(<#parameters#>) {
//            color =
//        }
    }
    
    //let passo = car(color: red, )
    
    
    //MARK: - STATE ステータス
    enum State {
        case busy           // 準備中
        case ready          // 準備完了
        case error          // エラー発生
    }
    public var state: ((State) -> Void)?
    
    //MARK: - STATE ステータス
    enum NextView {
        case syllabus           // 準備中
        case password
        case aboutThisApp
        case contactToDeveloper
    }
    public var next: ((NextView) -> Void)?
    
    enum IconEnum: String {
        case spIcon = "spIcon"
        case pcIcon = "pcIcon"
        case other = "other"
    }
    
//    private let dataManager = DataManager()
    private let model = Model()
    private let urlModel = UrlModel()
    private let webViewModel = WebViewModel()
    private var requestUrl: NSURLRequest?
    
    public var host = ""
    public var displayUrl = ""
    public var forwardDisplayUrl = ""
    
    public var imageSystemName = ""
    public var animationView = ""
    //  SyllabusViewの内容を渡され保存し、Webに入力する
    public var syllabusSubjectName = ""
    public var syllabusTeacherName = ""
    public var syllabusKeyword = ""
    public var syllabusSearchOnce = true
    
//    public var cAccount = "c611821006"
//    public var password = "q2KF2ZaxPtkL7Uu"
//    public var mailAdress = ""
//    public var passedCertification = false // ログインできていることを保証
//
//    public var reversePCtoSPIconName = "pcIcon"
//    public var reversePCtoSPIsEnabled = false
    
    enum Menu {
        case courceManagement
        case manaba
    }
    
    
    public func isDisplayUrlForPC() -> String { // boolにしたい
        
        switch displayUrl {
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
                print(webViewModel.url(.courceManagementHomePC))
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
