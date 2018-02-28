//
//  RepositoryViewModel.swift
//  github_trending_ios
//
//  Created by Kartupelis, John on 28/02/2018.
//  Copyright © 2018 Kartupelis, John. All rights reserved.
//

import Down
import Foundation
import ReactiveSwift

class RepositoryViewModel {

    let githubClient: GitHubClient
    let repository: GitHubRepository

    var readmeFetch: Disposable?

    let projectName = ObservableField<String>(value: "")
    let userName = ObservableField<String>(value: "")
    let description = ObservableField<String>(value: "")
    let starCount = ObservableField<String>(value: "")
    let forksCount = ObservableField<String>(value: "")
    let readmeMarkdown = ObservableField<NSAttributedString>(value: NSAttributedString())
    let imageURL : ObservableField<URL>
    let stargazersURL : ObservableField<URL>
    let forksURL: ObservableField<URL>
    let readmeLoadingVisible = ObservableField<Bool>(value: true)
    let readmeFailedLoadingVisible = ObservableField<Bool>(value: true)

    init(githubClient: GitHubClient,
         repository: GitHubRepository) {
        self.githubClient = githubClient
        self.repository = repository

        projectName.value = repository.name
        userName.value = repository.owner.name
        description.value = repository.description
        starCount.value = String(format: "%i Star%@", repository.stargazersCount, repository.stargazersCount > 1 ? "s" : "")
        forksCount.value = String(format: "%i Fork%@", repository.forksCount, repository.forksCount > 1 ? "s" : "")
        imageURL = ObservableField(value: repository.owner.avatarURL)
        stargazersURL = ObservableField(value: repository.stargazersURL)
        forksURL = ObservableField(value: repository.forksURL)
    }

    func loadReadme() {
        readmeFailedLoadingVisible.value = false
        readmeLoadingVisible.value = true

        readmeFetch = githubClient.getReadmeForRepository(repository: repository).startWithResult { [unowned self] result in
            if let readme = result.value {
                self.handleLoadingSuccessful(readme: readme)
            } else {
                self.handleLoadingFailure()
            }
        }
    }

    func cancelLoad() {
        readmeFetch?.dispose()
    }

    private func handleLoadingSuccessful(readme: GitHubReadme) {
        let down = Down(markdownString: readme.readmeMarkdown)
        let attributedString = try? down.toAttributedString()
        if let attributedString = attributedString {
            readmeMarkdown.value = attributedString
            readmeLoadingVisible.value = false
        } else {
            handleLoadingFailure()
        }
    }

    private func handleLoadingFailure() {
        readmeLoadingVisible.value = false
        readmeFailedLoadingVisible.value = true
    }
}
