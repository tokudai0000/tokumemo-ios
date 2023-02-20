//
//  CollectionView.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/02/14.
//

import UIKit
import FirebaseAnalytics

// MARK: - CollectionView
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    /// セル数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.menuLists.count
    }
    
    /// セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.homeCollectionCell, for: indexPath)! // fatalError
        
        let collectionList = viewModel.menuLists[indexPath.row]//viewModel.collectionLists[indexPath.row]
        
        let title = collectionList.title
        var icon = collectionList.image // fatalError
        
        // ログインが完了していないユーザーには鍵アイコンを表示(上書きする)
        if dataManager.loginState.completed == false, collectionList.isLockIconExists {
            icon = "lock.fill"
        }
        
        cell.setupCell(title: title, image: icon)
        return cell
    }
    
    /// セルがタップされた時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // タップされたセルの内容を取得
        let cell = viewModel.menuLists[indexPath.row]
        
        Analytics.logEvent("Cell[\(cell.id)]", parameters: nil) // Analytics
        
        // パスワード未登録、ロック画像ありのアイコン(ログインが必要)を押した場合
        if viewModel.hasRegisteredPassword() == false , cell.isLockIconExists {
            toast(message: "Settings -> パスワード設定から自動ログイン機能をONにしましょう")
            return
        }
        
        // 今年の成績だけ変化する為、保持する
        var loadUrlString = cell.url
        
        switch cell.id {
            case .syllabus:
                let vc = R.storyboard.input.inputViewController()!
                vc.type = .syllabus
                present(vc, animated: true)
                
            case .currentTermPerformance: // 今年の成績
                loadUrlString = viewModel.createCurrentTermPerformanceUrl()
                
            case .libraryCalendar:
                libraryAlart()
                return
                
            default:
                break
        }
        
        let vc = R.storyboard.web.webViewController()!
        vc.loadUrlString = loadUrlString
        present(vc, animated: true, completion: nil)
    }
    
    /// 図書館では常三島と蔵本の2つのカレンダーを選択させるためにアラートを表示
    private func libraryAlart() {
        // 常三島と蔵本を選択させるpopup(**Alert**)を表示 **推奨されたAlertの使い方ではない為、修正すべき**
        var alert:UIAlertController!
        //アラートコントローラーを作成する。
        alert = UIAlertController(title: "", message: "図書館の所在を選択", preferredStyle: UIAlertController.Style.alert)
        
        let alertAction = UIAlertAction(
            title: "常三島",
            style: UIAlertAction.Style.default,
            handler: { action in
                // 常三島のカレンダーURLを取得後、webView読み込み
                if let urlStr = self.viewModel.makeLibraryCalendarUrl(type: .main) {
                    let vcWeb = R.storyboard.web.webViewController()!
                    vcWeb.loadUrlString = urlStr
                    self.present(vcWeb, animated: true, completion: nil)
                }else{
                    AKLog(level: .ERROR, message: "[URL取得エラー]: 常三島開館カレンダー")
                    self.toast(message: "Error")
                }
            })
        
        let alertAction2 = UIAlertAction(
            title: "蔵本",
            style: UIAlertAction.Style.default,
            handler: { action in
                // 蔵本のカレンダーURLを取得後、webView読み込み
                if let urlStr = self.viewModel.makeLibraryCalendarUrl(type: .kura) {
                    let vcWeb = R.storyboard.web.webViewController()!
                    vcWeb.loadUrlString = urlStr
                    self.present(vcWeb, animated: true, completion: nil)
                }else{
                    AKLog(level: .ERROR, message: "[URL取得エラー]: 蔵本開館カレンダー")
                    self.toast(message: "Error")
                }
            })
        
        //アラートアクションを追加する。
        alert.addAction(alertAction)
        alert.addAction(alertAction2)
        present(alert, animated: true, completion:nil)
    }
}
