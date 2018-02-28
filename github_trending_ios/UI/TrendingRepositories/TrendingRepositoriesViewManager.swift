//
//  TrendingRepositoriesViewManager.swift
//  github_trending_ios
//
//  Created by Kartupelis, John on 28/02/2018.
//  Copyright © 2018 Kartupelis, John. All rights reserved.
//

import Foundation
import UIKit

class TrendingRepositoriesViewManager: ViewManager, TrendingRepositoriesViewModelDelegate {
    weak var delegate: ViewManagerDelegate?
    let githubClient: GitHubClient
    let storyboard: UIStoryboard
    let trendingRepositoriesIdentifier = "trendingRepositoriesViewController"

    init(githubClient: GitHubClient, storyboard: UIStoryboard) {
        self.githubClient = githubClient
        self.storyboard = storyboard
    }

    func start() {
        let viewModel = TrendingRepositoriesViewModel(githubClient: githubClient)
        viewModel.delegate = self

        let viewController = storyboard.instantiateViewController(withIdentifier: trendingRepositoriesIdentifier) as? TrendingRepositoriesViewController
        if let viewController = viewController {
            viewController.viewModel = viewModel
            delegate?.present(viewController: viewController)
        } else {
            fatalError("Failed to instantiate root view controller. Please check storyboard and bundle.")
        }
    }

    func openRepository(repository: GitHubRepository) {
        //TODO: open a view controller to view the individual repository's information
    }
}
