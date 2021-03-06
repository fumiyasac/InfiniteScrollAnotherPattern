//
//  UIViewControllerExtension.swift
//  InfiniteScrollAnotherPattern
//
//  Created by 酒井文也 on 2020/12/30.
//  Copyright © 2020 酒井文也. All rights reserved.
//

import Foundation
import UIKit

// UIViewControllerの拡張
extension UIViewController {

    // この画面のナビゲーションバーを設定するメソッド
    func setupNavigationBarTitle(_ title: String) {

        // NavigationControllerのデザイン調整を行う
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font : Constants.Fonts.navigationBarTitle,
            NSAttributedString.Key.foregroundColor : Constants.Colors.navigationBarTitle
        ]
        guard let navigationController = self.navigationController else {
            assertionFailure("UINavigationControllerを使用していない")
            return
        }
        navigationController.navigationBar.barTintColor = Constants.Colors.primary
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.titleTextAttributes = attributes

        // タイトルを入れる
        self.navigationItem.title = title
    }

    // 戻るボタンの「戻る」テキストを削除した状態にするメソッド
    func removeBackButtonText() {
        self.navigationController!.navigationBar.tintColor = .white
        if #available(iOS 14.0, *) {
            // MEMO: iOS14からは戻るボタンを長押しして戻ることができるのでその際に遷移元の画面でのタイトル名を取得可能にする
            self.navigationItem.backButtonDisplayMode = .minimal
            self.navigationItem.backButtonTitle = self.navigationItem.title
        } else {
            // 戻るボタンの文言を消す
            let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButtonItem
        }
    }
}
