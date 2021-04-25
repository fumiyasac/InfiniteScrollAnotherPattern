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

    // MEMO: APIリクエスト用の認証トークン
    var apiAuthenticatedToken: DefaultsKey<String?> {
        .init("ApiAuthenticatedToken")
    }
}
