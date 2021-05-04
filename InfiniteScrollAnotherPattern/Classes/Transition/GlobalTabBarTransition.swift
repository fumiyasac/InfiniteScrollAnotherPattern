//
//  GlobalTabBarTransition.swift
//  InfiniteScrollAnotherPattern
//
//  Created by 酒井文也 on 2021/05/04.
//  Copyright © 2021 酒井文也. All rights reserved.
//

import Foundation
import UIKit

// MEMO: UITabBarControllerの画面を切り替える際の動きはカスタムトランジションで実施する
// (参考) https://medium.com/@vialyx/ios-dev-course-uitabbarcontroller-animated-transitioning-50b341a150d

final class GlobalTabBarTransition: NSObject {

    // トランジションの秒数
    private let duration: TimeInterval = 0.18
}

// MARK: - UIViewControllerAnimatedTransitioning

extension GlobalTabBarTransition: UIViewControllerAnimatedTransitioning {

    // アニメーションの時間を定義する
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    // アニメーションの実装を定義する
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        // コンテキストを元にViewのインスタンスを取得する（存在しない場合は処理を終了）
        guard let destination = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }

        // MEMO: アルファ値と拡大縮小を組み合わせたCoreAnimationを実行する
        // 最初はアルファ(0.0) → アニメーション終了時はアルファ(1.0)
        destination.alpha = 0.0
        transitionContext.containerView.addSubview(destination)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            destination.alpha = 1.0
            destination.transform = .identity
        }, completion: { result in
            transitionContext.completeTransition(result)
        })
    }
}
