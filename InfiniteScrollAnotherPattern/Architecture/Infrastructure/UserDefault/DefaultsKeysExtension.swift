//
//  DefaultsKeysExtension.swift
//  InfiniteScrollAnotherPattern
//
//  Created by 酒井文也 on 2021/04/25.
//  Copyright © 2021 酒井文也. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

// MEMO: ライブラリ「SwiftyUserDefaults」を利用して管理する
extension DefaultsKeys {

    // MARK: - Property

    // MEMO: 選択しているタブを保持するための値
    var currentSelectedTab: DefaultsKey<GlobalTabBarController.Tab> {
        .init("CurrentSelectedTab", defaultValue: GlobalTabBarController.Tab.article)
    }
}
