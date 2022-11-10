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
        viewModel.getNewsData()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
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
    
    /*
     セルの高さを決めるメソッド
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(150)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        
        cell.setupCell(text: dataManager.newsTitleDatas[indexPath.section], date: dataManager.newsDateDatas[indexPath.section])
        
        return cell
    }
    
    
    /// セルを選択時のイベント
    ///
    /// [設定]と[戻る]のセルでは、テーブルをリロードする。
    /// それ以外では画面を消した後、それぞれ処理を行う
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let vcWeb = R.storyboard.web.webViewController()!
        let loadUrlString = dataManager.newsUrlDatas[indexPath[0]]
        vcWeb.loadUrlString = loadUrlString
        present(vcWeb, animated: true, completion: nil)
        
    }
}
