//
//  DependenciesContainer.swift
//  InfiniteScrollAnotherPattern
//
//  Created by 酒井文也 on 2021/04/06.
//  Copyright © 2021 酒井文也. All rights reserved.
//

import Foundation

// MEMO: DIコンテナ＆依存関係の解決を図る処理の例
// https://www.fabrizioduroni.it/2020/04/19/dependecy-injection-swift.html

// MEMO: DIコンテナ用クラス
final class DependeciesContainer {

    // MARK: - Singleton

    // MEMO: DIコンテナ自体はSingletonとして保持する
    static let shared = DependeciesContainer()

    private init() {}

    // MARK: - Properties

    // 対応するProtocol名と実装クラスを対応させたDictionaryを格納する変数
    // ※ resolve時にはこれを利用してインスタンス化する
    private var dependecies: [DependencyKey : Any] = [:]

    // MARK: - Function

    // Protocol名と実装クラスとの対応を登録する
    func register<T>(protocolType: T.Type, implementation: Any, name: String? = nil) {
        let dependencyKey = DependencyKey(protocolType: protocolType, name: name)
        dependecies[dependencyKey] = implementation
    }

    // 登録対象の実装クラスを登録する際に依存関係を登録するために利用する
    func resolve<T>(protocolType: T.Type, name: String? = nil) -> T {
        let dependencyKey = DependencyKey(protocolType: protocolType, name: name)
        if let dependency = dependecies[dependencyKey] as? T {
            return dependency
        } else {
            let protocolTypeName = NSString(string: "\(protocolType)").components(separatedBy: ".").last!
            fatalError("Can't resolve dependencies. Please register \(protocolTypeName) and resolve dependencies about using \(protocolTypeName)Impl class.")
        }
    }
}

// MEMO: Protocol名と実装クラスとの対応を登録する際のキーとなるものを作成するクラス
// ※ 例えば(local/remote)を分ける場合に同じProtocol名を使う場合に名前で特定できるようにするために利用する
final class DependencyKey: Hashable, Equatable {

    // MARK: - Properties

    private let protocolType: Any.Type
    private let name: String?

    // MARK: - Initializer

    init(protocolType: Any.Type, name: String? = nil) {
        self.protocolType = protocolType
        self.name = name
    }

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(protocolType))
        hasher.combine(name)
    }

    // MARK: - Equatable

    static func == (lhs: DependencyKey, rhs: DependencyKey) -> Bool {
        return lhs.protocolType == rhs.protocolType && lhs.name == rhs.name
    }
}
