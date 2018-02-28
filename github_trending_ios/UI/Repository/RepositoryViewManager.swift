//
//  RepositoryViewManager.swift
//  github_trending_ios
//
//  Created by Kartupelis, John on 28/02/2018.
//  Copyright © 2018 Kartupelis, John. All rights reserved.
//

import Foundation
import UIKit

class RepositoryViewManager: ViewManager {
    let viewControllerIdentifier = "repositoryViewController"
    let githubClient: GitHubClient
    let repository: GitHubRepository
    let storyboard: UIStoryboard
    var delegate: ViewManagerDelegate?

    init(githubClient: GitHubClient,
         repository: GitHubRepository,
         storyboard: UIStoryboard) {
        self.githubClient = githubClient
        self.repository = repository
        self.storyboard = storyboard
    }

    func start() {
        let viewModel = RepositoryViewModel(githubClient: githubClient, repository: repository)

        if let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier) as? RepositoryViewController {
            viewController.viewModel = viewModel
            delegate?.present(viewController: viewController)
        }
    }
}
