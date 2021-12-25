//
//  CellSortViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/12/06.
//

import UIKit
import FirebaseAnalytics

final class CellSortViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private let dataManager = DataManager.singleton
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // 編集モードの状態で表示
        editMode(isEditing: true)
    }
    
    
    // MARK: - IBAction
    @IBAction func editButton(_ sender: Any) {
        editMode(isEditing: !tableView.isEditing)
    }
    
    @IBAction func dissmissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
        Analytics.logEvent("allCellList", parameters:  [
            AnalyticsParameterItemName: "\(dataManager.menuLists[0])",
        ])
    }
    
    private func editMode(isEditing: Bool) {
        cellSort()
        tableView.setEditing(isEditing, animated: true)
        tableView.allowsMultipleSelectionDuringEditing = isEditing
        tableView.reloadData()
        
        if isEditing {
            editButton.setTitle("完了", for: .normal)
        } else {
            editButton.setTitle("編集", for: .normal)
        }
        
        if isEditing {
            for i in 0 ..< dataManager.menuLists.count {
                // display=true のセルを選択状態にする
                if dataManager.menuLists[i].isDisplay {
                    tableView.selectRow(at: [0,i], animated: true, scrollPosition: .bottom)
                }
            }
        }
    }
    
    private func cellSort() {
        var oldLists:[Constant.Menu] = dataManager.menuLists
        var newLists:[Constant.Menu] = []
        var counter = 0
        for i in 0..<dataManager.menuLists.count {
            if dataManager.menuLists[i].isDisplay {
                newLists.append(dataManager.menuLists[i])
                oldLists.remove(at: i - counter)
                counter += 1
            }
        }
        dataManager.menuLists = newLists + oldLists
    }
}


// MARK: - TableView
extension CellSortViewController: UITableViewDelegate, UITableViewDataSource {
    
    /// セクション内のセル数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.menuLists.count
    }
    
    /// cellの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.cellSort, for: indexPath)!
        tableCell.textLabel!.text = dataManager.menuLists[indexPath.item].title
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
        dataManager.changeSortOderMenuLists(sourceRow: sourceIndexPath.row, destinationRow: destinationIndexPath.row)
    }
    
    /// セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.isEditing {
            return 44
        }
        if dataManager.menuLists[indexPath.row].isDisplay {
            return 44
        }else{
            return 0
        }
    }
    
    /// セルを選択した時のイベント
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            // チェックボックスTrueの際、ここを通る。Falseの時didDeselectRowAtを通る
            dataManager.changeContentsMenuLists(row: indexPath.row, isDisplay: true)
        }
        
        if !tableView.isEditing {
            showRenameEditPopup(indexPath.row)
        }
    }
    
    /// 編集モード時、チェックが外された時
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        dataManager.changeContentsMenuLists(row: indexPath.row,isDisplay: false)
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
                self.dataManager.changeContentsMenuLists(row: indexPath, title: text)
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
            textField.placeholder = DataManager.singleton.menuLists[indexPath].title
        })
        
        present(popup, animated: true, completion: nil)
    }
}
