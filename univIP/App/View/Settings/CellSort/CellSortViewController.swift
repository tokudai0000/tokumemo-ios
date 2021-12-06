//
//  CellSortViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/12/06.
//

import UIKit

class CellSortViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIButton!
    
    private let dataManager = DataManager.singleton
    
    var editSituation = false
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    // MARK: - IBAction
    @IBAction func editButton(_ sender: Any) {
        // 編集モード, 使用モード反転
        editSituation = !editSituation
        // 編集モード時、複数選択を許可
        tableView.allowsMultipleSelectionDuringEditing = editSituation
        // 編集モード起動、停止
        tableView.setEditing(editSituation, animated: true)
        
        self.tableView.reloadData()
        
        if editSituation {
            editButton.setTitle("完了", for: .normal)
        } else {
            editButton.setTitle("編集", for: .normal)
        }
        
        // 編集モード時、display=true のセルを選択状態にする
        if editSituation {
            for i in 0 ..< dataManager.allCellList[0].count {
                if dataManager.allCellList[0][i].isDisplay {
                    self.tableView.selectRow(at: [0,i], animated: true, scrollPosition: .bottom)
                }
            }
        }
    }
    
    @IBAction func dissmissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
        // 編集モード判定
        if editSituation {
            // チェックボックスTrueの際、ここを通る。Falseの時didDeselectRowAtを通る
            dataManager.allCellList[0][indexPath.row].isDisplay = true
            dataManager.settingCellList = dataManager.allCellList[0]
            return
        }
        showAlart(indexPath.row)
    }
    
    /// 編集モード時、チェックが外された時
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        dataManager.allCellList[indexPath.section][indexPath.row].isDisplay = false
        dataManager.settingCellList = dataManager.allCellList[0]
    }
    
    
}

extension CellSortViewController: UITextFieldDelegate {
    private func showAlart(_ indexPath: Int) {
        let alert = UIAlertController(title: "名前の変更", message: nil, preferredStyle: .alert)

        let ok = UIAlertAction(title: "変更", style: .default, handler: {[weak alert] (action) -> Void in
            guard let textFields = alert?.textFields else {
                return
            }

            guard !textFields.isEmpty else {
                return
            }
            if let text = textFields[0].text {
                DataManager.singleton.allCellList[0][indexPath].title = text
                DataManager.singleton.settingCellList = DataManager.singleton.allCellList[0]
            }
            
            self.tableView.reloadData()
        })
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: { _ in self.tableView.reloadData() })
        
        
        //textfiledの追加
        alert.addTextField(configurationHandler: {(textField:UITextField!) -> Void in
            textField.delegate = self
            textField.placeholder = DataManager.singleton.allCellList[0][indexPath].title
        })
        
        alert.addAction(ok)
        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)
        
    }
}
