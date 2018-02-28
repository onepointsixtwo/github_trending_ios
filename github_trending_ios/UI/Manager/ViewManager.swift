//
//  ViewManager.swift
//  github_trending_ios
//
//  Created by Kartupelis, John on 28/02/2018.
//  Copyright © 2018 Kartupelis, John. All rights reserved.
//

import Foundation
import UIKit

protocol ViewManagerDelegate: class {
    func present(viewController: UIViewController)
    func dismiss(viewController: UIViewController)
}

protocol ViewManager: class {
    weak var delegate: ViewManagerDelegate? { get set }
    func start()
}




