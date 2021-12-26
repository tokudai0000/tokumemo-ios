//
//  FirstViewSettingViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/12/09.
//

import UIKit

final class FirstViewSettingViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var textField: UITextField!
    
    private var pickerView: UIPickerView = UIPickerView()
    
    private let dataManager = DataManager.singleton
    private var pickerList: [Constant.Menu] = []

    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerViewSetup()
        
        for item in dataManager.menuLists {
            // 現在設定している初期画面を表示
            if item.isInitView {
                textField.placeholder = item.title
            }
            // 初期画面に許可しているCellを表示する配列に追加
            if item.canInitView {
                pickerList.append(item)
            }
        }

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
            let pickerType = pickerList[pickerView.selectedRow(inComponent: 0)].id
            
            menuLists[i].isInitView = (menuType == pickerType)
        }
        dataManager.menuLists = menuLists
        // menuListsをUserDefaultsに保存
        dataManager.saveMenuLists()
        
        textField.text = "\(pickerList[pickerView.selectedRow(inComponent: 0)].title)"
    }
    
    // textfieldにpickerViewを埋め込む
    private func pickerViewSetup() {
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
    }
    
}


// MARK: - UIPickerViewDelegate
extension FirstViewSettingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // ドラムロールの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // ドラムロールの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerList.count
    }
    
    // ドラムロールの各タイトル
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerList[row].title
    }

}
