//
//  MainTutorialViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2021/12/19.
//

import UIKit
import EAIntroView

//class MainTutorialViewController: UIViewController, EAIntroDelegate {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let page1 = EAIntroPage()
//        page1.title = "インストールありがとうございます！！"
//        page1.desc = "まゆげじおの備忘録をご覧頂きありがとうございます！"
//
//        let page2 = EAIntroPage()
//        page2.title = "2ページ目"
//        page2.desc = "こんな感じでページを増やしていきます"
//
//        let page3 = EAIntroPage()
//        page3.title = "3ページ目"
//        page3.desc = "スキップボタンで飛ばす事も可能です。"
//
//        //ここでページを追加
//        let introView = EAIntroView(frame: self.view.bounds, andPages: [page1, page2, page3])
//
//        //スキップボタン
//        introView?.skipButton.setTitle("スキップ", for: UIControl.State.normal)
//
//        introView?.delegate = self
//        introView?.show(in: self.view, animateDuration: 1.0)
//    }
//
//}

extension MainViewController: EAIntroDelegate {

//    func introDidFinish(_ introView: EAIntroView!, wasSkipped: Bool) {
//        <#code#>
//    }
    
    func aaa() {

        let page1 = EAIntroPage()
        page1.title = "インストールありがとうございます！！"
        page1.desc = "まゆげじおの備忘録をご覧頂きありがとうございます！"

        let page2 = EAIntroPage()
        page2.title = "2ページ目"
        page2.desc = "こんな感じでページを増やしていきます"

        let page3 = EAIntroPage()
        page3.title = "3ページ目"
        page3.desc = "スキップボタンで飛ばす事も可能です。"

        //ここでページを追加
        let introView = EAIntroView(frame: self.view.bounds, andPages: [page1, page2, page3])

        //スキップボタン
        introView?.skipButton.setTitle("スキップ", for: UIControl.State.normal)
        introView?.backgroundColor = .red
        introView?.delegate = self
        introView?.show(in: self.view, animateDuration: 1.0)

    }

}
