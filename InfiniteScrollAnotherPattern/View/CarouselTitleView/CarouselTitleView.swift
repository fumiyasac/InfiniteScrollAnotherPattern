//
//  CarouselTitleView.swift
//  InfiniteScrollAnotherPattern
//
//  Created by 酒井文也 on 2019/08/03.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation
import UIKit

final class CarouselTitleView: CustomViewBase {

    @IBOutlet weak var leadingMargin: NSLayoutConstraint!
    @IBOutlet weak var trailingMargin: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!

    var contentKey: String = ""

    // MARK: - Class Function

    // ラベルに表示する文字列の長さを取得する
    class func getLabelWidth(title: String) -> CGFloat {
 
        // テキスト属性を定義する
        var attributes: [NSAttributedString.Key : Any] = [:]
        attributes[NSAttributedString.Key.font] = UIFont(name: "HiraKakuProN-W6", size: 11.0)!
        attributes[NSAttributedString.Key.foregroundColor] = UIColor.black

        // テキスト属性値を加味した幅を取得する
        let widthRect = title.boundingRect(
            with: CGSize(width: .greatestFiniteMagnitude, height: 13.0),
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context: nil)

        return ceil(widthRect.width)
    }

    // MARK: - Function

    // カルーセル表示用タイトルをセットする
    func setCarousel(title: String, contentKey: String, surplusWidth: CGFloat = 0.0) {

        // コンテンツ表示用のキー値を取得する
        self.contentKey = contentKey

        // タイトル文字列をラベルにセットする
        titleLabel.text = title
        titleLabel.sizeToFit()

        // 左右余白を追加する
        addSurplusWidth(surplusWidth)
    }

    // MARK: - Private Function

    // 行間の余りを左右マージン幅に加算する
    private func addSurplusWidth(_ surplus: CGFloat = 0.0) {
        if surplus > 0.0 {
            leadingMargin.constant += surplus / 2
            trailingMargin.constant += surplus / 2
        }
    }
}
