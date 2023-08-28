//
//  InputViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/08/09.
//  Copyright © 2021年　akidon0000
//

import UIKit
import RxSwift
import RxGesture
import Common

final class InputViewController: UIViewController {
    @IBOutlet private weak var titleLabel1: UILabel!
    @IBOutlet private weak var titleLabel2: UILabel!
    @IBOutlet private weak var TextField1: UITextField!
    @IBOutlet private weak var TextField2: UITextField!
    @IBOutlet private weak var TextSizeLabel1: UILabel!
    @IBOutlet private weak var TextSizeLabel2: UILabel!
    @IBOutlet private weak var MessageLabel1: UILabel!
    @IBOutlet private weak var MessageLabel2: UILabel!
    @IBOutlet private weak var UnderLine1: UIView!
    @IBOutlet private weak var UnderLine2: UIView!
    @IBOutlet private weak var resetButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var passwordViewButton: UIButton!
    @IBOutlet private weak var alertLabel: UILabel!
    @IBOutlet private weak var helpmessageAgreeButton: UIButton!

    private let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: nil, action: nil)

    private let disposeBag = DisposeBag()

    var viewModel: InputViewModelInterface!

    var alertController: UIAlertController!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDefaults()
        configureNavigation()
        configurePassword()
        binding()
        viewModel.input.viewDidLoad.accept(())
    }

    enum TextLabelType {
        case first
        case second
    }
    private func updateLabelWithText(text: String, for labelType: TextLabelType) {
        switch labelType {
        case .first:
            TextField1.text = text
            TextSizeLabel1.text = "\(text.count)/10"
        case .second:
            TextField2.text = text
            TextSizeLabel2.text = "\(text.count)/30"
        }
    }
}

// MARK: Binding
private extension InputViewController {
    func binding() {
        leftBarButton.rx
            .tap
            .subscribe(with: self) { owner, _ in
                owner.viewModel.input.didTapBackButton.accept(())
            }
            .disposed(by: disposeBag)

        helpmessageAgreeButton.rx
            .tap
            .subscribe(with: self) { owner, _ in
                owner.viewModel.input.didHelpmessageAgreeButton.accept(())
            }
            .disposed(by: disposeBag)

        resetButton.rx
            .tap
            .subscribe(with: self) { owner, _ in
                let alert = UIAlertController(title: "アラート表示", message: "学生番号とパスワードの情報をこのスマホから消去しますか？", preferredStyle:  UIAlertController.Style.alert)
                let defaultAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{ (action: UIAlertAction!) -> Void in
                    owner.updateLabelWithText(text: "", for: .first)
                    owner.updateLabelWithText(text: "", for: .second)
                    owner.viewModel.input.didTapResetOKButton.accept(())
                })
                let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{ (action: UIAlertAction!) -> Void in })
                alert.addAction(defaultAction)
                alert.addAction(cancelAction)
                owner.present(alert, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)

        registerButton.rx
            .tap
            .subscribe(with: self) { owner, _ in
                // textField.textはnilにはならずOptional("")となる(objective-c仕様の名残)
                guard let text1 = owner.TextField1.text else { return }
                guard let text2 = owner.TextField2.text else { return }
                owner.viewModel.input.didTapSaveButton.accept((text1, text2))
            }
            .disposed(by: disposeBag)

        passwordViewButton.rx
            .tap
            .subscribe(with: self) { owner, _ in
                // パスワードを●●で表記しているのを切り替え。ボタンの画像も切り替える。
                let image = owner.TextField2.isSecureTextEntry ? "eye" : "eye.slash"
                owner.passwordViewButton.setImage(UIImage(systemName: image), for: .normal)
                owner.TextField2.isSecureTextEntry = !owner.TextField2.isSecureTextEntry
            }
            .disposed(by: disposeBag)

        viewModel.output
            .textField1
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, text in
                // 生体認証等無く、パスワードを表示させることは危険なので、cアカウントのみ表示
                owner.updateLabelWithText(text: text, for: .first)
            }
            .disposed(by: disposeBag)

        viewModel.output
            .callDoneAlert
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                let alert = UIAlertController(title: "登録完了", message: "", preferredStyle: UIAlertController.Style.alert)
                let defaultAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{ (action: UIAlertAction!) -> Void in })
                alert.addAction(defaultAction)
                owner.present(alert, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Layout
private extension InputViewController {
    func configureDefaults() {
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

        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
    }

    func configureNavigation() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.setLeftBarButton(leftBarButton, animated: true)
        navigationItem.leftBarButtonItem?.tintColor = .black
    }

    func configurePassword() {
        title = "パスワード"
        titleLabel1.text = "cアカウント"
        titleLabel2.text = "パスワード"
        TextSizeLabel2.text = "0/30"
        TextField2.isSecureTextEntry = true
        resetButton.layer.cornerRadius = 25.0
        registerButton.setTitle("登録", for: .normal)
    }

    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

private extension InputViewController {
    /// TextFieldの種類
    enum FieldType: Int {
        case one = 0 // cアカウント
        case two = 1 // パスワード
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
        if let textField1 = TextField1.text {
            TextSizeLabel1.text = "\(textField1.count)/10"
        }
        if let textField2 = TextField2.text {
            TextSizeLabel2.text = "\(textField2.count)/30"
        }
    }
}
