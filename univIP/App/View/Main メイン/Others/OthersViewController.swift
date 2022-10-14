//
//  OthersViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/10/15.
//

import UIKit

class OthersViewController: UITableViewController {

    private let viewModel = OthersViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.collectionLists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.othersCell, for: indexPath)! // fatalError
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        cell.textLabel?.text = viewModel.collectionLists[indexPath.item].title

        return cell
    }
    
    
    /// セルを選択時のイベント
    ///
    /// [設定]と[戻る]のセルでは、テーブルをリロードする。
    /// それ以外では画面を消した後、それぞれ処理を行う
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // タップされたセルの内容
        let cell = viewModel.collectionLists[indexPath[1]]
        // どのセルが押されたか
        switch cell.id {
            case .password:
                let storyboard: UIStoryboard = UIStoryboard(name: "Password", bundle: nil)//遷移先のStoryboardを設定
                let nextView = storyboard.instantiateViewController(withIdentifier: "PasswordViewController") as! PasswordViewController//遷移先のViewControllerを設定
                nextView.title = "パスワード"
                self.navigationController?.pushViewController(nextView, animated: true)//遷移する
                return
                
            case .aboutThisApp:
                let storyboard: UIStoryboard = UIStoryboard(name: "AboutThisApp", bundle: nil)//遷移先のStoryboardを設定
                let nextView = storyboard.instantiateViewController(withIdentifier: "AboutThisAppViewController") as! AboutThisAppViewController//遷移先のViewControllerを設定
                nextView.title = "このアプリについて"
                self.navigationController?.pushViewController(nextView, animated: true)//遷移する
                return
                
            default:
                break
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
