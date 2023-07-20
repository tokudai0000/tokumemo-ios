//
//  NewsViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/10/23.
//

import UIKit

class NewsViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = NewsViewModel()
    
    // 共通データ・マネージャ
    private let dataManager = DataManager.singleton
    
    private var viewActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupIndicatorView()
        setupViewModelStateRecognizer()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Methods [Private]
    
    private func setupDefaults() {
        setStatusBarBackgroundColor(UIColor(red: 13/255, green: 58/255, blue: 151/255, alpha: 1.0))
        tableView.register(R.nib.newsTableViewCell)
        viewModel.updateNewsItems()
    }
    
    private func setupIndicatorView() {
        viewActivityIndicator = UIActivityIndicatorView()
        viewActivityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        viewActivityIndicator.center = self.view.center
        viewActivityIndicator.hidesWhenStopped = true
        viewActivityIndicator.style = UIActivityIndicatorView.Style.medium
        self.view.addSubview(viewActivityIndicator)
    }
    
    // ViewModelが変化したことの通知を受けて画面を更新する
    private func setupViewModelStateRecognizer() {
        // Protocol： ViewModelが変化したことの通知を受けて画面を更新する
        self.viewModel.state = { [weak self] (state) in
            guard let self = self else {
                fatalError()
            }
            DispatchQueue.main.async {
                switch state {
                case .busy: // 通信中
                    self.viewActivityIndicator.startAnimating() // クルクルスタート
                    break
                    
                case .ready: // 通信完了
                    self.viewActivityIndicator.stopAnimating() // クルクルストップ
                    self.tableView.reloadData()
                    break
                    
                case .error:
                    break
                }
            }
        }
    }
}


extension NewsViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.newsItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.newsTableViewCell, for: indexPath)!
        let item = viewModel.newsItems[indexPath.section]
        cell.setupCell(text: item.title, date: item.date)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true) // セルの選択状態を解除
        let vc = R.storyboard.web.webViewController()!
        vc.loadUrlString = viewModel.newsItems[indexPath[0]].urlStr
        present(vc, animated: true, completion: nil)
    }
}
