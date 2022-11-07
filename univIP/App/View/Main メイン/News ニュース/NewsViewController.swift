//
//  NewsViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/10/23.
//

import UIKit

class NewsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let viewModel = NewsViewModel()
    private let dataManager = DataManager.singleton
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initViewModel()
    }
    
    /// ViewModel初期化
    private func initViewModel() {
        // Protocol： ViewModelが変化したことの通知を受けて画面を更新する
        self.viewModel.state = { [weak self] (state) in
            guard let self = self else {
                fatalError()
            }
            DispatchQueue.main.async {
                switch state {
                    case .busy: // 通信中
                        break
                        
                    case .ready: // 通信完了
                        self.tableView.reloadData()
                        break
                        
                        
                    case .error:
                        break
                        
                }//end switch
            }
        }
    }
}

extension NewsViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataManager.newsTitleDatas.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.newsCell, for: indexPath)! // fatalError
        
        
        //        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        cell.textLabel?.text = dataManager.newsTitleDatas[indexPath.section]
        
        return cell
    }
    
    
    /// セルを選択時のイベント
    ///
    /// [設定]と[戻る]のセルでは、テーブルをリロードする。
    /// それ以外では画面を消した後、それぞれ処理を行う
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        // タップされたセルの内容
//        let cell = viewModel.collectionLists[indexPath.section][indexPath[1]]
//        // どのセルが押されたか
//        switch cell.id {
//            case .password:
//                let storyboard: UIStoryboard = UIStoryboard(name: "Password", bundle: nil)//遷移先のStoryboardを設定
//                let nextView = storyboard.instantiateViewController(withIdentifier: "PasswordViewController") as! PasswordViewController//遷移先のViewControllerを設定
//                nextView.title = "パスワード"
//                self.navigationController?.pushViewController(nextView, animated: true)//遷移する
//                return
//
//            case .customize:
//                let storyboard: UIStoryboard = UIStoryboard(name: "Password", bundle: nil)//遷移先のStoryboardを設定
//                let nextView = storyboard.instantiateViewController(withIdentifier: "PasswordViewController") as! PasswordViewController//遷移先のViewControllerを設定
//                nextView.title = "パスワード"
//                self.navigationController?.pushViewController(nextView, animated: true)//遷移する
//                return
//
//            case .aboutThisApp:
//                let storyboard: UIStoryboard = UIStoryboard(name: "AboutThisApp", bundle: nil)//遷移先のStoryboardを設定
//                let nextView = storyboard.instantiateViewController(withIdentifier: "AboutThisAppViewController") as! AboutThisAppViewController//遷移先のViewControllerを設定
//                nextView.title = "このアプリについて"
//                self.navigationController?.pushViewController(nextView, animated: true)//遷移する
//                return
//
//            case .contactUs:
//                let webPage = "https://www.google.com/?hl=ja"
//                let safariVC = SFSafariViewController(url: NSURL(string: webPage)! as URL)
//                present(safariVC, animated: true, completion: nil)
//                return
//
//            case .officialSNS:
//                let webPage = "https://twitter.com/tokumemo0000"
//                let safariVC = SFSafariViewController(url: NSURL(string: webPage)! as URL)
//                present(safariVC, animated: true, completion: nil)
//                return
//
//            case .homePage:
//                let webPage = "https://lit.link/developers"
//                let safariVC = SFSafariViewController(url: NSURL(string: webPage)! as URL)
//                present(safariVC, animated: true, completion: nil)
//                return
//
//            case .termsOfService:
//                let webPage = "https://github.com/tokudai0000/document/blob/main/tokumemo/terms/TermsOfService.txt"
//                let safariVC = SFSafariViewController(url: NSURL(string: webPage)! as URL)
//                present(safariVC, animated: true, completion: nil)
//                return
//
//            case .privacyPolicy:
//                let webPage = "https://github.com/tokudai0000/document/blob/main/tokumemo/terms/PrivacyPolicy.txt"
//                let safariVC = SFSafariViewController(url: NSURL(string: webPage)! as URL)
//                present(safariVC, animated: true, completion: nil)
//                return
//
//            case .license:
//                let webPage = "https://www.google.com/?hl=ja"
//                let safariVC = SFSafariViewController(url: NSURL(string: webPage)! as URL)
//                present(safariVC, animated: true, completion: nil)
//                return
//
//            case .acknowledgments:
//                let webPage = "https://www.google.com/?hl=ja"
//                let safariVC = SFSafariViewController(url: NSURL(string: webPage)! as URL)
//                present(safariVC, animated: true, completion: nil)
//                return
//
//
//            default:
//                break
//        }
    }
}
