//
//  CarouselContentsView.swift
//  InfiniteScrollAnotherPattern
//
//  Created by 酒井文也 on 2019/08/03.
//  Copyright © 2019 酒井文也. All rights reserved.
//

import Foundation
import UIKit

final class CarouselContentsView: CustomViewBase {

    private (set)var carouselTitle: String?
    private (set)var contentKey: String?

    @IBOutlet private weak var carouselTitleLabel: UILabel!

    // MARK: - Function

    // コンテンツ表示用タイトルをセットする
    func setContents(title: String, contentKey: String) {

        // コンテンツ表示用のキー値を取得する
        self.contentKey = contentKey

        // コンテンツ文字列をラベルにセットする
        carouselTitle = title
        carouselTitleLabel.text = title
    }
}
