//
//  RepositoryViewModel.swift
//  github_trending_ios
//
//  Created by Kartupelis, John on 28/02/2018.
//  Copyright © 2018 Kartupelis, John. All rights reserved.
//

import Foundation

class RepositoryViewModel {

    let githubClient: GitHubClient
    let repository: GitHubRepository



    init(githubClient: GitHubClient,
         repository: GitHubRepository) {
        self.githubClient = githubClient
        self.repository = repository
    }

    func loadReadme() {

    }

    func cancelLoad() {

    }
}
