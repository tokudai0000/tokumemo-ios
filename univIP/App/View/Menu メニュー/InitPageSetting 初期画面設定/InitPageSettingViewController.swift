//
//  FirstViewSettingViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/12/09.
//

import UIKit
import FirebaseAnalytics

final class InitPageSettingViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var textField: UITextField!
    
    public let viewModel = InitPageSettingModel()
    
    private var pickerView: UIPickerView = UIPickerView()
    private let dataManager = DataManager.singleton
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSetup()
    }
    
    
    // MARK: - IBAction
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // pickerViewの決定ボタン
    @objc func done() {
        // textFieldの編集終了
        textField.endEditing(true)
        
        var menuLists = dataManager.menuLists
        for i in 0..<menuLists.count {
            // 選択された内容とインデックス番号を照合
            let menuType = menuLists[i].id
            let pickerType = viewModel.pickerList[pickerView.selectedRow(inComponent: 0)].id
            
            menuLists[i].isInitView = (menuType == pickerType)
        }
        dataManager.menuLists = menuLists
        // menuListsをUserDefaultsに保存
        dataManager.saveMenuLists()
        
        textField.text = viewModel.pickerList[pickerView.selectedRow(inComponent: 0)].title
        
        // アナリティクスを送信
        Analytics.logEvent("FirstViewSetting", parameters: ["initViewName": viewModel.pickerList[pickerView.selectedRow(inComponent: 0)].title])
        
    }
    
    // MARK: - Private func
    /// FirstViewSettingViewControllerの初期セットアップ
    private func initSetup() {
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spaceItem, doneItem], animated: true)
        
        // インプットビュー設定
        textField.inputView = pickerView
        textField.inputAccessoryView = toolbar
        
        textField.placeholder = viewModel.searchTitleCell()
    }
}


// MARK: - UIPickerViewDelegate
extension InitPageSettingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    /// ドラムロールの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /// ドラムロールの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.pickerList.count
    }
    
    /// ドラムロールの各タイトル
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.pickerList[row].title
    }
}
