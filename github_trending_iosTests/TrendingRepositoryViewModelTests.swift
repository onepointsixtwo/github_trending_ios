//
//  TrendingRepositoryViewModelTests.swift
//  github_trending_iosTests
//
//  Created by Kartupelis, John on 28/02/2018.
//  Copyright © 2018 Kartupelis, John. All rights reserved.
//

import UIKit
import XCTest
@testable import github_trending_ios

class TrendingRepositoryViewModelTests: XCTestCase {
    private var testNetworkStack: TestNetworkStack?
    private var githubClient: GitHubClient?
    private var viewModel: TrendingRepositoriesViewModel?
    private var delegate: FakeTrendingRepositoriesViewModelDelegate?

    override func setUp() {
        delegate = FakeTrendingRepositoriesViewModelDelegate()
        testNetworkStack = TestNetworkStack()
        githubClient = GitHubClient(baseURL: URL(string: "http://api.github.com")!, network: testNetworkStack!)
        viewModel = TrendingRepositoriesViewModel(githubClient: githubClient!)
        viewModel?.delegate = delegate
    }

    func testSuccessfullyLoadingRepositories() {
        let data = getDataFromFile(forClass: type(of: self), withName: "good_repositories_response", andExtension: "json")
        testNetworkStack?.addResponse(data: data)
        testNetworkStack?.error = false

        viewModel?.fetchRepositories()

        XCTAssertEqual(1, viewModel?.displayRepositories.value.count)
        XCTAssertFalse(viewModel?.showError.value == true)
        XCTAssertFalse(viewModel?.showLoading.value == true)
        let firstRepo = viewModel?.displayRepositories.value[0]
        XCTAssertEqual("hangzhou_house_knowledge", firstRepo?.projectName)
        XCTAssertEqual("8277 stars", firstRepo?.starsCount)
        XCTAssertEqual("2017年买房经历总结出来的买房购房知识分享给大家，希望对大家有所帮助。买房不易，且买且珍惜。Sharing the knowledge of buy an own house that according  to the experience at hangzhou in 2017 to all the people. It's not easy to buy a own house, so I hope that it would be useful to everyone.", firstRepo?.description)
    }

    func testFailureLoadingRepositories() {
        testNetworkStack?.error = true

        viewModel?.fetchRepositories()

        XCTAssertEqual(0, viewModel?.displayRepositories.value.count)
        XCTAssertTrue(viewModel?.showError.value == true)
        XCTAssertFalse(viewModel?.showLoading.value == true)
    }

    func testFailureWithSuccessfulRetry() {
        testNetworkStack?.error = true
        viewModel?.fetchRepositories()

        XCTAssertEqual(0, viewModel?.displayRepositories.value.count)
        XCTAssertTrue(viewModel?.showError.value == true)
        XCTAssertFalse(viewModel?.showLoading.value == true)

        let data = getDataFromFile(forClass: type(of: self), withName: "good_repositories_response", andExtension: "json")
        testNetworkStack?.addResponse(data: data)
        testNetworkStack?.error = false

        viewModel?.fetchRepositories()

        XCTAssertEqual(1, viewModel?.displayRepositories.value.count)
        XCTAssertFalse(viewModel?.showError.value == true)
        XCTAssertFalse(viewModel?.showLoading.value == true)
    }

    func testFilteringRepositoriesWithSearchStrings() {
        let data = getDataFromFile(forClass: type(of: self), withName: "good_repositories_response", andExtension: "json")
        testNetworkStack?.addResponse(data: data)
        testNetworkStack?.error = false

        viewModel?.fetchRepositories()
        XCTAssertEqual(1, viewModel?.displayRepositories.value.count)


        // Use various valid and invalid search strings and check that they either do or don't give a result after filtering
        // We search the project name and description (see good_repositories_response.json)
        viewModel?.filterRepositoriesBySearch(search: "onomatopoeia")
        XCTAssertEqual(0, viewModel?.displayRepositories.value.count)

        viewModel?.filterRepositoriesBySearch(search: "hangzhou")
        XCTAssertEqual(1, viewModel?.displayRepositories.value.count)

        // Check we're searching case insensitively
        viewModel?.filterRepositoriesBySearch(search: "UsEfUl To EvErYoNe")
        XCTAssertEqual(1, viewModel?.displayRepositories.value.count)

        viewModel?.filterRepositoriesBySearch(search: "this doesn't exist")
        XCTAssertEqual(0, viewModel?.displayRepositories.value.count)

        viewModel?.filterRepositoriesBySearch(search: "")
        XCTAssertEqual(1, viewModel?.displayRepositories.value.count)
    }

    func testRepositoryPressed() {
        let data = getDataFromFile(forClass: type(of: self), withName: "good_repositories_response", andExtension: "json")
        testNetworkStack?.addResponse(data: data)
        testNetworkStack?.error = false

        viewModel?.fetchRepositories()

        viewModel?.repositoryAtIndexPressed(index: 0)

        XCTAssertEqual(1, delegate?.openRepositoryCalls)
        XCTAssertNotNil(delegate?.lastOpenedRepository)
        XCTAssertEqual("hangzhou_house_knowledge", delegate?.lastOpenedRepository?.name)
    }
}

private class FakeTrendingRepositoriesViewModelDelegate: TrendingRepositoriesViewModelDelegate {
    var openRepositoryCalls = 0
    var lastOpenedRepository : GitHubRepository?

    func openRepository(repository: GitHubRepository) {
        openRepositoryCalls += 1
        lastOpenedRepository = repository
    }
}


