//
//  TrendingRepositoriesViewModel.swift
//  github_trending_ios
//
//  Created by Kartupelis, John on 28/02/2018.
//  Copyright © 2018 Kartupelis, John. All rights reserved.
//

import ReactiveSwift
import UIKit

class TrendingRepositoriesViewModel {

    weak var delegate: TrendingRepositoriesViewModelDelegate?
    private let githubClient: GitHubClient
    private var repositories = [GitHubRepository]()
    private var filteredRepositories = [GitHubRepository]()

    private var currentFetch: Disposable?

    let showLoading = ObservableField<Bool>(value: true)
    let showError = ObservableField<Bool>(value: false)
    let displayRepositories = ObservableField<[TrendingRepository]>(value: [TrendingRepository]())

    init(githubClient: GitHubClient) {
        self.githubClient = githubClient
    }

    func fetchRepositories() {
        showLoading.value = true
        showError.value = false

        let request = self.githubClient.getTrendingRepositories()
        currentFetch = request.startWithResult { [unowned self] result in
            if let repositories = result.value {
                self.handleSuccessfullyFetchedRepositories(repos: repositories)
            } else {
                self.handleErrorFetchingRepositories(error: result.error)
            }
        }
    }

    func cancelFetchingRepositories() {
        currentFetch?.dispose()
    }

    func repositoryAtIndexPressed(index: Int) {
        delegate?.openRepository(repository: filteredRepositories[index])
    }

    func filterRepositoriesBySearch(search: String) {
        if search.isEmpty {
            filteredRepositories = repositories
        } else {
            let lowercaseSearch = search.lowercased()
            filteredRepositories = repositories.filter { repository in
                repository.description.lowercased().contains(lowercaseSearch) ||
                repository.name.lowercased().contains(lowercaseSearch)
            }
        }
        updateDisplayrepositories()
    }

    private func handleErrorFetchingRepositories(error: GitHubError?) {
        showLoading.value = false
        showError.value = true
    }

    private func handleSuccessfullyFetchedRepositories(repos: [GitHubRepository]) {
        showLoading.value = false
        repositories = repos
        filteredRepositories = repos
        updateDisplayrepositories()
    }

    private func updateDisplayrepositories() {
        let displayRepositories = filteredRepositories.map {
            self.displayRepositoryFromRepository(repository: $0)
        }
        self.displayRepositories.value = displayRepositories
    }

    private func displayRepositoryFromRepository(repository: GitHubRepository) -> TrendingRepository {
        let projectName = repository.name
        let starsCount = String(format:"%i stars", repository.stargazersCount)
        let description = repository.description
        return TrendingRepository(projectName: projectName, starsCount: starsCount, description: description)
    }
}

protocol TrendingRepositoriesViewModelDelegate: class {
    func openRepository(repository: GitHubRepository)
}

struct TrendingRepository {
    let projectName: String
    let starsCount: String
    let description: String

    init(projectName: String,
         starsCount: String,
         description: String) {
        self.projectName = projectName
        self.starsCount = starsCount
        self.description = description
    }
}


