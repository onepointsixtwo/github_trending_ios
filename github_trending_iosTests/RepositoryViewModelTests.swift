//
//  RepositoryViewModelTests.swift
//  github_trending_iosTests
//
//  Created by Kartupelis, John on 28/02/2018.
//  Copyright © 2018 Kartupelis, John. All rights reserved.
//

import Foundation
import XCTest
@testable import github_trending_ios

class RepositoryViewModelTests: XCTestCase {
    
    private var testNetworkStack: TestNetworkStack?
    private var githubClient: GitHubClient?
    private var viewModel: RepositoryViewModel?

    override func setUp() {
        testNetworkStack = TestNetworkStack()
        githubClient = GitHubClient(baseURL: URL(string: "http://api.github.com")!, network: testNetworkStack!)

        let user = GitHubUser(id: 1, name: "User name", avatarURL: URL(string: "https://api.github.com")!)
        let url = URL(string: "https://api.github.com")!
        let repository = GitHubRepository(id: 1, name: "Repo Name", owner: user, description: "Repo Description", forksURL: url, stargazersURL: url, forksCount: 2, stargazersCount: 1)
        viewModel = RepositoryViewModel(githubClient: githubClient!, repository: repository)
    }

    func testInitialValuesSetCorrectly() {
        XCTAssertEqual("Repo Name", viewModel?.projectName.value)
        XCTAssertEqual("User name", viewModel?.userName.value)
        XCTAssertEqual("Repo Description", viewModel?.description.value)
        XCTAssertEqual("2 Forks", viewModel?.forksCount.value)
        XCTAssertEqual("1 Star", viewModel?.starCount.value)
        XCTAssertEqual("https://api.github.com", viewModel?.imageURL.value.absoluteString)
        XCTAssertEqual("https://api.github.com", viewModel?.forksURL.value.absoluteString)
        XCTAssertEqual("https://api.github.com", viewModel?.stargazersURL.value.absoluteString)
    }

    func testSuccessfullyLoadingReadme() {
        let data = getDataFromFile(forClass: type(of: self), withName: "good_readme_url_response", andExtension: "json")
        let data2 = getDataFromFile(forClass: type(of: self), withName: "readme_content", andExtension: "txt")
        testNetworkStack?.addResponse(data: data)
        testNetworkStack?.addResponse(data: data2)
        testNetworkStack?.error = false

        viewModel?.loadReadme()

        // The extra '\n ' is required because Xcode forces a newline in the readme_content text file
        XCTAssertEqual("This is a test README.md\n ", viewModel?.readmeMarkdown.value.string)
        XCTAssertEqual(false, viewModel?.readmeLoadingVisible.value)
        XCTAssertEqual(false, viewModel?.readmeFailedLoadingVisible.value)
    }

    func testFailedToLoadReadme() {
        testNetworkStack?.error = true

        viewModel?.loadReadme()

        XCTAssertEqual(false, viewModel?.readmeLoadingVisible.value)
        XCTAssertEqual(true, viewModel?.readmeFailedLoadingVisible.value)
    }

    func testRetryLoadReadmeSuccessAfterFail() {
        testNetworkStack?.error = true

        viewModel?.loadReadme()

        let data = getDataFromFile(forClass: type(of: self), withName: "good_readme_url_response", andExtension: "json")
        let data2 = getDataFromFile(forClass: type(of: self), withName: "readme_content", andExtension: "txt")
        testNetworkStack?.addResponse(data: data)
        testNetworkStack?.addResponse(data: data2)
        testNetworkStack?.error = false

        viewModel?.loadReadme()

        XCTAssertEqual("This is a test README.md\n ", viewModel?.readmeMarkdown.value.string)
        XCTAssertEqual(false, viewModel?.readmeLoadingVisible.value)
        XCTAssertEqual(false, viewModel?.readmeFailedLoadingVisible.value)
    }
}
