//
//  PassWordSettingsViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit

final class InputViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var titleLabel1: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var TextField1: UITextField!
    @IBOutlet weak var TextField2: UITextField!
    @IBOutlet weak var TextSizeLabel1: UILabel!
    @IBOutlet weak var TextSizeLabel2: UILabel!
    @IBOutlet weak var MessageLabel1: UILabel!
    @IBOutlet weak var MessageLabel2: UILabel!
    @IBOutlet weak var UnderLine1: UIView!
    @IBOutlet weak var UnderLine2: UIView!
    
    @IBOutlet weak var passwordViewButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var registerButton: UIButton!
    
    public var delegate : HomeViewController?
    
    private let dataManager = DataManager.singleton
    
    enum DisplayType {
        case password
        case favorite
        case syllabus
    }
    public var type: DisplayType!
    
    // MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initSetup(type)
        
    }
    
    // MARK: - IBAction
    /// パスワードの表示、非表示モード
    @IBAction func passwordViewChangeButton(_ sender: Any) {
        let image = TextField2.isSecureTextEntry ? "eye" : "eye.slash"
        passwordViewButton.setImage(UIImage(systemName: image), for: .normal)
        TextField2.isSecureTextEntry = !TextField2.isSecureTextEntry
    }
    
    @IBAction func resetButton(_ sender: Any) {
        let alert = UIAlertController(title: "アラート表示",
                                      message: "学生番号とパスワードの情報をこのスマホから消去しますか？",
                                      preferredStyle:  UIAlertController.Style.alert)
        
        let defaultAction = UIAlertAction(title: "OK",
                                          style: UIAlertAction.Style.default,
                                          handler:{ (action: UIAlertAction!) -> Void in
            self.dataManager.studentNumber = ""
            self.dataManager.password = ""
            self.initSetup(self.type)
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル",
                                                        style: UIAlertAction.Style.cancel,
                                                        handler:{ (action: UIAlertAction!) -> Void in })
        
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func registrationButton(_ sender: Any) {
        // textField.textはnilにはならずOptional("")となる(objective-c仕様の名残)
        guard let text1 = TextField1.text else { return }
        guard let text2 = TextField2.text else { return }
        
        if text1.isEmpty {
            MessageLabel1.text = "空欄です"
            textFieldCursorSetup(fieldType: .one, cursorType: .error)
            return
        }
        
        if text2.isEmpty {
            MessageLabel2.text = "空欄です"
            textFieldCursorSetup(fieldType: .two, cursorType: .error)
            return
        }
        
        if type == .password, text1.prefix(1) == "c" {
            MessageLabel1.text = "cアカウントではなく、学生番号です"
            textFieldCursorSetup(fieldType: .one, cursorType: .error)
            return
        }
        
        // エラー表示が出ていた場合、画面を初期化
        initSetup(type)
        
        switch type {
            case .password:
                // KeyChianに保存する
                dataManager.studentNumber = text1
                dataManager.password = text2
           
            case .favorite:
                let item = MenuListItem(title: text2, id: .favorite, image: "questionmark.folder", url: text1, isLockIconExists: false, isHiddon: false)
                addMenuContents(item)
                
                alert(title: "♪ 登録完了 ♪",
                      message: "以降、アプリを開くたびに自動ログインの機能が使用できる様になりました。")
                
            case .syllabus:
                dataManager.syllabusSubjectName = text1
                dataManager.syllabusTeacherName = text2
                // シラバス画面を消去後、Web画面を表示
                dismiss(animated: false, completion: {
                    let vc = R.storyboard.web.webViewController()!
                    vc.loadUrlString = Url.syllabus.string()
                    self.delegate!.present(vc, animated: true, completion: nil)
                })
                
            default:
                fatalError()
        }
    }
        
    // MARK: - Private
    /// PasswordSettingsViewControllerの初期セットアップ
    private func initSetup(_ type: DisplayType) {
        textFieldCursorSetup(fieldType: .one, cursorType: .normal)
        textFieldCursorSetup(fieldType: .two, cursorType: .normal)
        TextField1.delegate = self
        TextField2.delegate = self
        TextField1.borderStyle = .none
        TextField2.borderStyle = .none
        MessageLabel1.textColor = .red
        MessageLabel2.textColor = .red
        MessageLabel1.text = ""
        MessageLabel2.text = ""
        registerButton.layer.cornerRadius = 5.0
        
        switch type {
            case .password:
                title = "パスワード"
                titleLabel1.text = "学生番号"
                titleLabel2.text = "パスワード"
                TextField1.text = dataManager.studentNumber
                TextField2.text = dataManager.password
                TextSizeLabel1.text = "\(dataManager.studentNumber.count)/10"
                TextSizeLabel2.text = "\(dataManager.password.count)/100"
                TextField2.isSecureTextEntry = true
                resetButton.layer.cornerRadius = 25.0
                
            case .favorite:
                titleLabel1.text = ""
                titleLabel2.text = ""
                TextField1.text = ""
                TextField2.text = ""
                TextSizeLabel1.text = "0/100"
                TextSizeLabel2.text = "0/100"
            
            case .syllabus:
                titleLabel1.text = ""
                titleLabel2.text = ""
                TextField1.text = ""
                TextField2.text = ""
                TextSizeLabel1.text = "0/100"
                TextSizeLabel2.text = "0/100"
        }
    }
    
    /// MenuLists内の要素を追加する。その都度UserDefaultsに保存する
    /// - Parameters:
    ///   - menuItem: 追加したいお気に入り設定
    private func addMenuContents(_ menuItem: MenuListItem) {
        var lists:[MenuListItem] = dataManager.menuLists
        lists.append(menuItem)
        dataManager.menuLists = lists
    }
    
    private var alertController: UIAlertController!
    private func alert(title:String, message:String) {
        alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: .default,
                                                handler: nil))
        present(alertController, animated: true)
    }
    
    /// TextFieldの種類
    enum FieldType: Int {
        case one = 0 // 科目名
        case two = 1 // 教員名
    }
    /// カーソルの表示種類
    enum CursorType {
        case normal // 非選択状態
        case focus // 選択状態
        case error // 入力エラー状態
    }
    /// TextFieldの状態を変化させる
    /// - Parameters:
    ///   - fieldType: 変化させたいTextFieldの種類
    ///   - cursorType: 変化させたい状態
    private func textFieldCursorSetup(fieldType: FieldType, cursorType: CursorType) {
        switch fieldType {
            case .one:
                switch cursorType {
                    case .normal:
                        // 非選択状態
                        UnderLine1.backgroundColor = .lightGray
                        
                    case .focus:
                        // 選択状態
                        // カーソルの色
                        TextField1.tintColor = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 1.0)
                        UnderLine1.backgroundColor = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 1.0)
                        
                    case .error:
                        TextField1.tintColor = .red
                        UnderLine1.backgroundColor = .red
                }
            case .two:
                switch cursorType {
                    case .normal:
                        UnderLine2.backgroundColor = .lightGray
                        
                    case .focus:
                        TextField2.tintColor = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 1.0)
                        UnderLine2.backgroundColor = UIColor(red: 13/255, green: 169/255, blue: 251/255, alpha: 1.0)
                        
                    case .error:
                        TextField2.tintColor = .red
                        UnderLine2.backgroundColor = .red
                }
        }
    }
}

// MARK: - UITextFieldDelegate
extension InputViewController: UITextFieldDelegate {
    // textField編集前
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let textFieldTag = FieldType(rawValue: textField.tag)
        
        switch textFieldTag {
            case .one:
                textFieldCursorSetup(fieldType: .one, cursorType: .focus)
                
            case .two:
                textFieldCursorSetup(fieldType: .two, cursorType: .focus)
                
            case .none:
                AKLog(level: .FATAL, message: "TextFieldTagが不正")
                fatalError()
        }
    }
    /// textField編集後
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldCursorSetup(fieldType: .one, cursorType: .normal)
        textFieldCursorSetup(fieldType: .two, cursorType: .normal)
    }
    /// text内容が変更されるたびに
    func textFieldDidChangeSelection(_ textField: UITextField) {
        TextSizeLabel1.text = "\(TextField1.text?.count ?? 0)/10"
        TextSizeLabel2.text = "\(TextField2.text?.count ?? 0)/100"
    }
}
