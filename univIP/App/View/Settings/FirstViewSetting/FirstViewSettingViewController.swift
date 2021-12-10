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
    private let list: [CellList] = [CellList(type: .courceManagementHomePC,      url: Url.courceManagementHomePC.string(),      title: "教務事務システムPC版"),
                                    CellList(type: .courceManagementHomeMobile,  url: Url.courceManagementHomeMobile.string(),  title: "教務事務システムMobile版"),
                                    CellList(type: .manabaHomePC,                url: Url.manabaHomePC.string(),                title: "マナバPC版"),
                                    CellList(type: .manabaHomeMobile,            url: Url.manabaHomeMobile.string(),            title: "マナバMobile版"),
                                    CellList(type: .libraryWeb,                  url: Url.libraryHome.string(),                 title: "[図書館]Webサイト"),
                                    CellList(type: .libraryMyPage,               url: Url.libraryLogin.string(),                title: "[図書館]MyPage"),
                                    CellList(type: .libraryCalendar,             url: Url.libraryCalendar.string(),             title: "[図書館]開館カレンダー"),
                                    CellList(type: .syllabus,                    url: Url.syllabus.string(),                    title: "シラバス"),
                                    CellList(type: .mailService,                 url: Url.mailService.string(),                 title: "メール"),
                                    CellList(type: .tokudaiCareerCenter,         url: Url.tokudaiCareerCenter.string(),         title: "キャリア支援室"),
                                    CellList(type: .systemServiceList,           url: Url.systemServiceList.string(),           title: "システムサービス一覧"),
                                    CellList(type: .eLearningList,               url: Url.eLearningList.string(),               title: "Eラーニング一覧"),
                                    CellList(type: .universityWeb,               url: Url.universityHome.string(),              title: "大学サイト")]
    
    
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
        
        // 全てfalseに初期化
        for i in 0..<dataManager.allCellList[0].count {
            dataManager.allCellList[0][i].initialView = false
        }
        
        for i in 0..<dataManager.allCellList[0].count {
            if dataManager.allCellList[0][i].type == list[pickerView.selectedRow(inComponent: 0)].type {
                dataManager.allCellList[0][i].initialView = true
            }
        }
        
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
}
