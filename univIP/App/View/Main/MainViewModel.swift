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
    
    var displayURL = ""
    let model = Model()
    // Dos攻撃を防ぐ為、1度ログイン処理したら結果の有無に関わらず終了させる
    private var onlyOnceForLogin = false
    private let dataManager = DataManager()
    
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
    
    func openUrl(_ registrant: String, notRegistrant: String = "nil", isAlert: Bool = false) -> NSURLRequest? {
        var notRegi = notRegistrant
        if notRegistrant == "nil" {
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
    
    func viewPosisionType(posisionY: Double) {
        print(posisionY)
        
        switch posisionY {
        case 0.0:
            imageSystemName = "chevron.down"
            animationView = "rightButtonDown"

            
        default:
            imageSystemName = "chevron.up"
            animationView = "rightButtonUp"
        }
        
    }
    
}
