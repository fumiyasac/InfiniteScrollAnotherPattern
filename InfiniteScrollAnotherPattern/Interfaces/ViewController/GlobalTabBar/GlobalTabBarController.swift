//
//  GlobalTabBarController.swift
//  InfiniteScrollAnotherPattern
//
//  Created by 酒井文也 on 2021/05/04.
//  Copyright © 2021 酒井文也. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

// MARK: - Protocols (for ScrollToTop)

// MEMO: GlobalTabBarに直接配置しているViewControllerにてScrollToTopを実行するためのプロトコル定義
protocol GlobalTabBarFirstViewControllerScrollable: AnyObject {
    func firstViewControllerScrollToTop()
}

final class GlobalTabBarController: UITabBarController {

    // MARK: - Properties

    // MEMO: UITabBarの切り替え時に実行するカスタムトランジションのクラス
    private let tabBarTransition = GlobalTabBarTransition()

    // MEMO: UITabBarの切り替え時に実行するカスタムトランジションのクラス
    // (参考) https://bit.ly/3h4A3OX
    private var bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.4, 0.9, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(0.3)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        return bounceAnimation
    }()

    // MARK: - Enum

    enum Tab: Int, CaseIterable, DefaultsSerializable {

        case article
        case video
        case profile
        case setting

        func getTitle() -> String {
            switch self {
            case .article:
                return "記事一覧"
            case .video:
                return "動画一覧"
            case .profile:
                return "プロフィール"
            case .setting:
                return "設定と質問"
            }
        }

        func getIcon() -> String {
            switch self {
            case .article:
                return "photo.fill.on.rectangle.fill"
            case .video:
                return "video.bubble.left.fill"
            case .profile:
                return "person.circle.fill"
            case .setting:
                return "gearshape.2.fill"
            }
        }
    }

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

        setupGlobalTabBar()
    }

    // UITabBarItemが押下された際に実行される処理
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

        // MEMO: UITabBarに配置されているUIImageView要素に対してアニメーションさせるための処理
        // (参考) https://bit.ly/2VCP5Am
        guard let index = tabBar.items?.firstIndex(of: item), tabBar.subviews.count > index + 1, let imageView = tabBar.subviews[index + 1].subviews[1] as? UIImageView else {
            return
        }
        imageView.layer.add(bounceAnimation, forKey: nil)
    }

    // MARK: - Private Function

    private func setupGlobalTabBar() {

        // MEMO: UITabBarControllerDelegateの宣言
        self.delegate = self

        // TODO: 画面が仕上がり次第構築する
        // MEMO: 各画面のCoodinatorとUINavigationControllerをインスタンス化する
        // 1. article
        // 2. video
        // 3. profile
        // 4. setting

        // MEMO: 各画面の土台となるUINavigationControllerをセットする

        // MEMO: GlobalTabBarControllerに配置する画面に対応するCoodinatorの処理を実行する

        // UITabBarに表示する画面を決める
        Tab.allCases.enumerated().forEach { (index, tab) in

            // 該当ViewControllerのタイトルの設定
            self.viewControllers?[index].title = tab.getTitle()

            // 該当ViewControllerのUITabBar要素の設定
            self.viewControllers?[index].tabBarItem.tag = index
            self.viewControllers?[index].tabBarItem.setTitleTextAttributes(Constants.TabBarStyles.normalAttributes, for: [])
            self.viewControllers?[index].tabBarItem.setTitleTextAttributes(Constants.TabBarStyles.selectedAttributes, for: .selected)
            self.viewControllers?[index].tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: -1.0)
            self.viewControllers?[index].tabBarItem.image = UIImage(
                systemName: tab.getIcon(),
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .black)
            )!.withTintColor(Constants.TabBarStyles.normalColor, renderingMode: .alwaysOriginal)
            self.viewControllers?[index].tabBarItem.selectedImage = UIImage(
                systemName: tab.getIcon(),
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .black)
            )!.withTintColor(Constants.TabBarStyles.selectedColor, renderingMode: .alwaysOriginal)
        }
    }
}

// MARK: - UITabBarControllerDelegate

extension GlobalTabBarController: UITabBarControllerDelegate {

    // UITabBarControllerの画面切り替え遷移が実行された場合の遷移アニメーションの定義
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return tabBarTransition
    }

    // UITabBarControllerの画面切り替え遷移が実行されようとするタイミングで実行する処理の定義
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        guard let viewControllers = viewControllers else {
            return false
        }

        // MEMO: タブ押下時に選択したindex値に対応するViewControllerが画面切り替え先のViewControllerと一致する場合
        if viewController == viewControllers[selectedIndex], let navigationController = viewController as? UINavigationController {

            // MEMO: GlobalTabBarに直接配置しているViewControllerの場合にはScrollToTopの処理を実施する
            // 補足: 対象のUICiewControllerの内部にてUIPageViewControllerを利用している場合にはその中のViewControllerに対して当該処理を実施する
        }
        return true
    }
}
