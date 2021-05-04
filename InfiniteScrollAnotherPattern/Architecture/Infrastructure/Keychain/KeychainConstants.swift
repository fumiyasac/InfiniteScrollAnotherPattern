//
//  KeychainConstants.swift
//  InfiniteScrollAnotherPattern
//
//  Created by 酒井文也 on 2021/05/04.
//  Copyright © 2021 酒井文也. All rights reserved.
//

import Foundation

struct KeychainConstants {

    // このアプリの「Bundle Indentifier」名
    static let bundleIdentifier = Bundle.main.bundleIdentifier!

    // keychainAccessのKey名
    static let keychainAccessKeyName = "jsonAccessToken"

    // JWTのprefix名
    static let jwtTokenPrefix = "Bearer "
}
