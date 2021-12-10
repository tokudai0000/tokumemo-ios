//
//  CellSortViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/12/06.
//

import UIKit
import FirebaseAnalytics

class CellSortViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private let dataManager = DataManager.singleton

    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    // MARK: - IBAction
    @IBAction func editButton(_ sender: Any) {
        let editing = !tableView.isEditing
        tableView.setEditing(editing, animated: true)
        tableView.allowsMultipleSelectionDuringEditing = editing
        tableView.reloadData()
        
        if editing {
            editButton.setTitle("完了", for: .normal)
        } else {
            editButton.setTitle("編集", for: .normal)
        }
        
        if editing {
            for i in 0 ..< dataManager.allCellList[0].count {
                // display=true のセルを選択状態にする
                if dataManager.allCellList[0][i].isDisplay {
                    tableView.selectRow(at: [0,i], animated: true, scrollPosition: .bottom)
                }
            }
        }
    }
    
    @IBAction func dissmissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
        Analytics.logEvent("allCellList", parameters:  [
            AnalyticsParameterItemName: "\(dataManager.allCellList[0])",
          ])
    }
}


// MARK: - TableView
extension CellSortViewController: UITableViewDelegate, UITableViewDataSource {
    
    /// セクション内のセル数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.allCellList[0].count
    }
    
    /// cellの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.cellSort, for: indexPath)!
        tableCell.textLabel!.text = dataManager.allCellList[0][indexPath.item].title
        tableCell.textLabel!.font = UIFont.systemFont(ofSize: 17)
        return tableCell
    }
    
    /// 並び替え
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if sourceIndexPath.section == proposedDestinationIndexPath.section {
            return proposedDestinationIndexPath
        }
        return sourceIndexPath
    }
    
    /// 「編集モード」並び替え検知
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let todo = dataManager.allCellList[sourceIndexPath.section][sourceIndexPath.row]
        dataManager.allCellList[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        dataManager.allCellList[sourceIndexPath.section].insert(todo, at: destinationIndexPath.row)
        dataManager.settingCellList = dataManager.allCellList[0]
    }
    
    /// セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    /// セルを選択した時のイベント
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            // チェックボックスTrueの際、ここを通る。Falseの時didDeselectRowAtを通る
            dataManager.allCellList[0][indexPath.row].isDisplay = true
            dataManager.settingCellList = dataManager.allCellList[0]
        }
        
        if !tableView.isEditing {
            showRenameEditPopup(indexPath.row)
        }
    }
    
    /// 編集モード時、チェックが外された時
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        dataManager.allCellList[indexPath.section][indexPath.row].isDisplay = false
        dataManager.settingCellList = dataManager.allCellList[0]
    }
}

extension CellSortViewController: UITextFieldDelegate {
    private func showRenameEditPopup(_ indexPath: Int) {
        // popupではなく、Alertを使用
        let popup = UIAlertController(title: "名前の変更", message: nil, preferredStyle: .alert)

        let ok = UIAlertAction(title: "変更",
                               style: .default,
                               handler: {[weak popup] (action) -> Void in
            guard let textField = popup?.textFields else {
                return
            }
            if textField.isEmpty { return }

            if let text = textField[0].text {
                DataManager.singleton.allCellList[0][indexPath].title = text
                DataManager.singleton.settingCellList = DataManager.singleton.allCellList[0]
            }
            self.tableView.reloadData()
        })
        
        let cancel = UIAlertAction(title: "キャンセル",
                                   style: .cancel,
                                   handler: { _ in self.tableView.reloadData() })
        
        popup.addAction(ok)
        popup.addAction(cancel)
        popup.addTextField(configurationHandler: {(textField:UITextField!) -> Void in
            textField.delegate = self
            textField.placeholder = DataManager.singleton.allCellList[0][indexPath].title
        })

        present(popup, animated: true, completion: nil)
    }
}
