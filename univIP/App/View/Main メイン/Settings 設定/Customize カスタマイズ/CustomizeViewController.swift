//
//  CellSortViewController.swift
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
        reload()
    }
    
    private func reload() {
        // 編集状態について
        tableView.setEditing(true, animated: false)
        // 複数の選択を許可するかどうか
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.reloadData()
        
        for i in 0 ..< dataManager.menuLists.count {
            if !dataManager.menuLists[i].isHiddon {
                // display=true のセルを選択状態にする
                // animatiedを有効にすると画面が選択cellの最下部へフォーカスする　**false推奨**
                tableView.selectRow(at: [0,i], animated: false, scrollPosition: .none)
            }
        }
    }
    
    /// MenuLists内の要素を削除する。その都度UserDefaultsに保存する
    /// - Parameters:
    ///   - row: index
    private func deleteMenuContents(row: Int) {
        var lists:[MenuListItem] = dataManager.menuLists
        lists.remove(at: row)
        dataManager.menuLists = lists
    }
    
    /// MenuLists内の要素を変更する。その都度UserDefaultsに保存する
    /// - Parameters:
    ///   - row: index
    ///   - title: タイトルの変更
    ///   - isDisplay: リストで表示する
    private func changeMenuIsHiddon(row: Int, isHiddon: Bool) {
        var lists:[MenuListItem] = dataManager.menuLists
        lists[row].isHiddon = isHiddon
        dataManager.menuLists = lists
    }
    
    /// MenuLists内の順番を変更する。その都度UserDefaultsに保存する
    /// - Parameters:
    ///   - sourceRow: 移動させたいcellのindex
    ///   - destinationRow: 挿入場所のindex
    public func sortMenu(sourceRow: Int, destinationRow: Int) {
        var lists:[MenuListItem] = dataManager.menuLists
        let todo = lists[sourceRow]
        lists.remove(at: sourceRow)
        lists.insert(todo, at: destinationRow)
        dataManager.menuLists = lists
    }
}


// MARK: - TableView
extension CustomizeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // セクション内のセル数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.menuLists.count
    }
    
    // cellの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.customizeTableCell, for: indexPath)! // fatalError
        tableCell.textLabel?.text = dataManager.menuLists[indexPath.row].title
        tableCell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        return tableCell
    }
    
    // 並び替え
    func tableView(_ tableView: UITableView,
                   targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath,
                   toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        return proposedDestinationIndexPath
        
    }
    
    // 「編集モード」並び替え検知
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // 並び替えを更新
        sortMenu(sourceRow: sourceIndexPath.row, destinationRow: destinationIndexPath.row)
    }
    
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    // セルを選択した時のイベント
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 表示許可情報を更新
        // チェックボックスTrueの際、ここを通る。Falseの時didDeselectRowAtを通る
        changeMenuIsHiddon(row: indexPath.row, isHiddon: false)
    }
    
    // 編集モード時、チェックが外された時
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
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
