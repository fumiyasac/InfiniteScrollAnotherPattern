//
//  ApiAuthenticatedToken.swift
//  InfiniteScrollAnotherPattern
//
//  Created by 酒井文也 on 2021/04/25.
//  Copyright © 2021 酒井文也. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

// MEMO: SwiftyUserDefaultsで利用したいためにDefaultsSerializableプロトコルに適合させる
struct ApiAuthenticatedToken: DefaultsSerializable, Equatable, Codable {

    // MARK: - Properties

    let token: String
    let expiredAt: String

    // MARK: - Initializer

    init(token: String, expiredAt: String) {
        self.token = token
        self.expiredAt = expiredAt
    }

    // MARK: - Equatable

    static func == (lhs: ApiAuthenticatedToken, rhs: ApiAuthenticatedToken) -> Bool {
        return lhs.token == rhs.token && lhs.expiredAt == rhs.expiredAt
    }
}
