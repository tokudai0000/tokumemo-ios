//
//  CustomizeViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/12/06.
//

import UIKit
import FirebaseAnalytics

final class CustomizeViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    private let dataManager = DataManager.singleton
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.setEditing(true, animated: false)
        tableView.allowsMultipleSelectionDuringEditing = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reload() // Home画面でのカスタマイズ機能で並び替えをタブ移動した際に反映するため
        
    }
    
    private func reload() {
        tableView.reloadData()
        let lists = dataManager.menuLists
        for i in 0 ..< lists.count {
            if lists[i].isHiddon == false {
                // display=true のセルを選択状態にする
                // animatiedを有効にすると画面が選択cellの最下部へフォーカスする　**false推奨**
                tableView.selectRow(at: [0,i], animated: false, scrollPosition: .none)
            }
        }
    }
    
    /// 要素を削除
    private func deleteMenuContents(row: Int) {
        var lists:[MenuItemList] = dataManager.menuLists
        lists.remove(at: row)
        dataManager.menuLists = lists
    }
    
    /// 要素を変更
    private func changeMenuIsHiddon(row: Int, isHiddon: Bool) {
        var lists:[MenuItemList] = dataManager.menuLists
        lists[row].isHiddon = isHiddon
        dataManager.menuLists = lists
    }
    
    /// 順番を変更
    public func sortMenu(sourceRow: Int, destinationRow: Int) {
        var lists:[MenuItemList] = dataManager.menuLists
        let todo = lists[sourceRow]
        lists.remove(at: sourceRow)
        lists.insert(todo, at: destinationRow)
        dataManager.menuLists = lists
    }
}


// MARK: - TableView
extension CustomizeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.menuLists.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.customizeTableCell, for: indexPath)! // fatalError
        tableCell.textLabel?.text = dataManager.menuLists[indexPath.row].title
        //        tableCell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        return tableCell
    }
    
    // 並び替え
    //    func tableView(_ tableView: UITableView,
    //                   targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath,
    //                   toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
    //        return proposedDestinationIndexPath
    //    }
    
    // 「編集モード」並び替え検知
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        sortMenu(sourceRow: sourceIndexPath.row, destinationRow: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // チェックボックスTrueの際、ここを通る。Falseの時didDeselectRowAtを通る
        changeMenuIsHiddon(row: indexPath.row, isHiddon: false)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // チェックボックスFalseの際、ここを通る。
        // お気に入りであれば、非表示ではなく削除する
        if dataManager.menuLists[indexPath.row].id == .favorite {
            deleteMenuContents(row: indexPath.row)
            reload()
            return
        }
        // 表示許可情報を更新
        changeMenuIsHiddon(row: indexPath.row, isHiddon: true)
    }
}
