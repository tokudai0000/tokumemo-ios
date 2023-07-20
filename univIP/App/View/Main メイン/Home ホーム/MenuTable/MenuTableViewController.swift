//
//  MenuTableViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/07/20.
//

import UIKit

class MenuTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var menuTableView: UITableView!


    public var menuLists: [MenuItemList] = []

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

//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let cell = menuLists[indexPath.row]
//        switch cell.id {
//        case .password:
//            let vc = R.storyboard.input.inputViewController()!
//            vc.type = .password
//            navigationController?.pushViewController(vc, animated: true)
//        case .favorite:
//            let vc = R.storyboard.input.inputViewController()!
//            vc.type = .favorite
//            navigationController?.pushViewController(vc, animated: true)
//        case .customize:
//            let vc = R.storyboard.customize.customizeViewController()!
//            vc.title = "カスタマイズ"
//            navigationController?.pushViewController(vc, animated: true)
//        default:
//            let vc = R.storyboard.web.webViewController()!
//            vc.loadUrlString = cell.url!
//            present(vc, animated: true, completion: nil)
//        }
//    }
}
