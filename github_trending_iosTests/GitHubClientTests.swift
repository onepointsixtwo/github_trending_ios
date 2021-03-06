//
//  GitHubClientTests.swift
//  github_trending_iosTests
//
//  Created by Kartupelis, John on 27/02/2018.
//  Copyright © 2018 Kartupelis, John. All rights reserved.
//

import Foundation
import ReactiveSwift
import XCTest
@testable import github_trending_ios

class GitHubClientTests: XCTestCase {

    var githubClient: GitHubClient?
    var mockNetworkStack = TestNetworkStack()

    override func setUp() {
        githubClient = GitHubClient(baseURL: URL(string: "https://api.github.com")!, network: mockNetworkStack)
    }

    func testFetchingTrendingRepositories() {
        let data = getDataFromFile(forClass: type(of: self), withName: "good_repositories_response", andExtension: "json")
        mockNetworkStack.addResponse(data: data)

        let result = githubClient?.getTrendingRepositories().single()?.value
        XCTAssertNotNil(result)
        XCTAssertEqual(1, result?.count)
    }

    func testFetchingReadme() {
        let user = GitHubUser(id: 1, name: "", avatarURL: URL(string: "https://api.github.com")!)
        let url = URL(string: "https://api.github.com")!
        let repository = GitHubRepository(id: 1, name: "", owner: user, description: "", forksURL: url, stargazersURL: url, forksCount: 1, stargazersCount: 1)

        let data = getDataFromFile(forClass: type(of: self), withName: "good_readme_url_response", andExtension: "json")
        let data2 = getDataFromFile(forClass: type(of: self), withName: "readme_content", andExtension: "txt")
        mockNetworkStack.addResponse(data: data)
        mockNetworkStack.addResponse(data: data2)

        let readme = githubClient?.getReadmeForRepository(repository: repository).single()?.value
        XCTAssertNotNil(readme)
        XCTAssertEqual("This is a test README.md\n", readme?.readmeMarkdown)
    }
}
