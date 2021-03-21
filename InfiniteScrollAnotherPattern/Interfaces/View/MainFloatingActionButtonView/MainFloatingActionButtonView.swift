//
//  MainFloatingActionButtonView.swift
//  InfiniteScrollAnotherPattern
//
//  Created by 酒井文也 on 2021/03/21.
//  Copyright © 2021 酒井文也. All rights reserved.
//

import Foundation
import UIKit

// MARK: - MainFloatingActionButtonViewDelegate

protocol MainFloatingActionButtonViewDelegate: NSObjectProtocol {
    func MainFloatingActionButtonTapped()
}

final class MainFloatingActionButtonView: CustomViewBase {

    // MARK: - Property

    weak var delegate: MainFloatingActionButtonViewDelegate?
}
