//
//  NewsViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/10/23.
//

import UIKit
import FirebaseAnalytics

class NewsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = NewsViewModel()
    private let dataManager = DataManager.singleton
    
    private var ActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initViewModel()
        initActivityIndicator()
        
        viewModel.getNewsData()
        viewModel.getImage()
    
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
                        // クルクルスタート
                        self.ActivityIndicator.startAnimating()
                        break
                        
                    case .ready: // 通信完了
                        // クルクルストップ
                        self.ActivityIndicator.stopAnimating()
                        self.tableView.reloadData()
                        break
                        
                        
                    case .error:
                        break
                        
                }//end switch
            }
        }
    }
    
    private func initActivityIndicator() {
        // ActivityIndicatorを作成＆中央に配置
        ActivityIndicator = UIActivityIndicatorView()
        ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        ActivityIndicator.center = self.view.center
        
        // クルクルをストップした時に非表示する
        ActivityIndicator.hidesWhenStopped = true
        
        // 色を設定
        ActivityIndicator.style = UIActivityIndicatorView.Style.medium
        
        //Viewに追加
        self.view.addSubview(ActivityIndicator)
    }
}

extension NewsViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.newsDatas.count
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.newsTableViewCell, for: indexPath)!
        
        cell.setupCell(text: viewModel.newsDatas[indexPath.section].title,
                       date: viewModel.newsDatas[indexPath.section].date,
                       imgUrlStr: viewModel.newsImgStr[indexPath.section])
        
        return cell
    }
    
    
    /// セルを選択時のイベント
    ///
    /// [設定]と[戻る]のセルでは、テーブルをリロードする。
    /// それ以外では画面を消した後、それぞれ処理を行う
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        Analytics.logEvent("NewsTable", parameters: nil) // Analytics
        let vcWeb = R.storyboard.web.webViewController()!
        let loadUrlString = viewModel.newsDatas[indexPath[0]].urlStr
        vcWeb.loadUrlString = loadUrlString
        present(vcWeb, animated: true, completion: nil)
        
    }
}
