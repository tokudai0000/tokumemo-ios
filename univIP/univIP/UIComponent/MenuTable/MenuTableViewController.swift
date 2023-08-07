//
//  MenuTableViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/07/20.
//

import UIKit

class MenuTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var menuTableView: UITableView!

//    let viewModel = HomeViewModel()
    public var menuLists: [MenuItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuLists.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableCell", for: indexPath)
        cell.textLabel?.text = menuLists[indexPath.row].title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = menuLists[indexPath.row]
        switch cell.id {
        case .syllabus:
            let vc = R.storyboard.input.inputViewController()!
            vc.type = .syllabus
            present(vc, animated: true)
        case .libraryCalendar:
            libraryAlart()
        case .currentTermPerformance:
            let vc = R.storyboard.web.webViewController()!
//            vc.loadUrlString = viewModel.createCurrentTermPerformanceUrl()
            present(vc, animated: true, completion: nil)

        default:
            let vc = R.storyboard.web.webViewController()!
            vc.loadUrlString = cell.url!
            self.present(vc, animated: true, completion: nil)
        }
    }

    /// 図書館では常三島と蔵本の2つのカレンダーを選択させるためにアラートを表示
    /// 常三島と蔵本を選択させるpopup(**Alert**)を表示 **推奨されたAlertの使い方ではない為、修正すべき**
    private func libraryAlart() {
//        var alert:UIAlertController!
//        let viewModel = HomeViewModel()
//        alert = UIAlertController(title: "", message: "図書館の所在を選択", preferredStyle: UIAlertController.Style.alert)
//        let alertAction = UIAlertAction(
//            title: "常三島",
//            style: UIAlertAction.Style.default,
//            handler: { action in
//                // 常三島のカレンダーURLを取得後、webView読み込み
//                if let urlStr = viewModel.makeLibraryCalendarUrl(type: .main) {
//                    let vcWeb = R.storyboard.web.webViewController()!
//                    vcWeb.loadUrlString = urlStr
//                    self.present(vcWeb, animated: true, completion: nil)
//                }else{
//                    AKLog(level: .ERROR, message: "[URL取得エラー]: 常三島開館カレンダー")
////                    self.toast(message: "Error")
//                }
//            })
//        let alertAction2 = UIAlertAction(
//            title: "蔵本",
//            style: UIAlertAction.Style.default,
//            handler: { action in
//                // 蔵本のカレンダーURLを取得後、webView読み込み
//                if let urlStr = viewModel.makeLibraryCalendarUrl(type: .kura) {
//                    let vcWeb = R.storyboard.web.webViewController()!
//                    vcWeb.loadUrlString = urlStr
//                    self.present(vcWeb, animated: true, completion: nil)
//                }else{
//                    AKLog(level: .ERROR, message: "[URL取得エラー]: 蔵本開館カレンダー")
////                    self.toast(message: "Error")
//                }
//            })
//        alert.addAction(alertAction)
//        alert.addAction(alertAction2)
//        present(alert, animated: true, completion:nil)
    }

}
