//
//  FirstViewSettingViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/12/09.
//

import UIKit

class FirstViewSettingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - IBOutlet
    @IBOutlet weak var textField: UITextField!
    
    var pickerView: UIPickerView = UIPickerView()
    let dataManager = DataManager.singleton
    private let list: [CellList] = DataManager.singleton.allCellList[0]
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        // インプットビュー設定
        textField.inputView = pickerView
        textField.inputAccessoryView = toolbar
    }
    
    
    // MARK: - IBAction
    @IBAction func dissmissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func done() {
        textField.endEditing(true)
        
        for i in 0..<dataManager.allCellList[0].count {
            dataManager.allCellList[0][i].initialView = false
        }
        dataManager.allCellList[0][pickerView.selectedRow(inComponent: 0)].initialView = true
        dataManager.settingCellList = dataManager.allCellList[0]
        
        textField.text = "\(list[pickerView.selectedRow(inComponent: 0)].title)"
    }
    
    
    // ドラムロールの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // ドラムロールの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    // ドラムロールの各タイトル
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row].title
    }
    
    /*
     // ドラムロール選択時
     func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
     self.textField.text = list[row]
     }
     */
}
