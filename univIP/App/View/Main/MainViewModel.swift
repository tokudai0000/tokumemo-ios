//
//  MainViewModel.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/10/27.
//

import Foundation

class MainViewModel: NSObject {
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
        case ready          // 準備完了
        case error          // エラー発生
    }
    public var next: ((NextView) -> Void)?
    
    private let dataManager = DataManager()
    var test = ""
    var displayURL = ""
    let model = Model()
    // Dos攻撃を防ぐ為、1度ログイン処理したら結果の有無に関わらず終了させる
    private var onlyOnceForLogin = false
    
    var requestUrl: NSURLRequest?
    
    private enum iconEnum: String {
        case spIcon = "spIcon"
        case pcIcon = "pcIcon"
    }
    
    func reversePCandSP() -> String {
        
        switch displayURL {
        case model.urls["courceManagementHomeSP"]!.url:
            UserDefaults.standard.set("pc", forKey: "CMPCtoSP")
            return R.image.spIcon.name
            
            
        case model.urls["courceManagementHomePC"]!.url:
            UserDefaults.standard.set("sp", forKey: "CMPCtoSP")
            return R.image.pcIcon.name
            
            
        case model.urls["manabaSP"]!.url:
            UserDefaults.standard.set("pc", forKey: "ManabaPCtoSP")
            return R.image.spIcon.name
            
            
        case model.urls["manabaPC"]!.url:
            UserDefaults.standard.set("sp", forKey: "ManabaPCtoSP")
            return R.image.pcIcon.name
            
            
        default:
            return "No Image"
        }
    }
    
    func openUrl(_ registrant: String, notRegistrant: String = "", isAlert: Bool = false) -> NSURLRequest? {
        var notRegi = notRegistrant
        if notRegistrant == "" {
            notRegi = registrant
        }

//        webViewDisplay(bool: true)
//        onlyOnceForLogin = false
        print(isAlert)
        // 登録者判定
        if isRegistrant(){
            if let url = URL(string:registrant){
                return NSURLRequest(url: url)
                
            }
//            AKLog()
//            webView.load(request as URLRequest)
            
            
        }else{
            if isAlert {
//                toast(message: "パスワード設定をすることで利用できます", type: "bottom")
//                webViewDisplay(bool: false)
                return nil
            }

            if let url = URL(string: notRegi){
                return NSURLRequest(url: url)
                
            }
        }
        return nil
        
    }
    
    // アカウント登録者判定　登録者：true　　非登録者：false
    private func isRegistrant() -> Bool{
        if (dataManager.cAccount == "" &&
                dataManager.passWord == ""){
            return false
            
        }else{
            return true
        }
    }
    var imageSystemName = ""
    var animationView = ""
    //  SyllabusViewの内容を渡され保存し、Webに入力する
    var syllabusSubjectName = ""
    var syllabusTeacherName = ""
    var syllabusKeyword = ""
    var syllabusSearchOnce = true
    var syllabusPassdThroughOnce = false
    
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
    
    func registrantDecision() -> Bool{
        if (dataManager.cAccount == "" &&
                dataManager.passWord == ""){
            return false
            
        }else{
            return true
        }
    }
    
//    func popupView(_ scene: String) -> BaseViewController {
//
//        switch scene {
//        case "firstView":
//            return R.storyboard.syllabus.syllabusViewController()!
//
//        case "syllabus":
//            return R.storyboard.syllabus.syllabusViewController()!
//
////            self.present(vc, animated: true, completion: nil)
////            vc.delegateMain = self
//        case "password":
//            return R.storyboard.passwordSettings.passwordSettingsViewController()!
////            self.present(vc, animated: true, completion: nil)
////            vc.delegateMain = self
//        case "aboutThisApp":
//            return R.storyboard.aboutThisApp.aboutThisAppViewController()!
////            self.present(vc, animated: true, completion: nil)
//        case "contactToDeveloper":
//            return R.storyboard.contactToDeveloper.contactToDeveloperViewController()!
////            self.present(vc, animated: true, completion: nil)
//        default:
//            return
//        }
//
//    }
    
}
