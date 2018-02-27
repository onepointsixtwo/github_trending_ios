//
//  GithubParsersTests.swift
//  github_trending_iosTests
//
//  Created by Kartupelis, John on 27/02/2018.
//  Copyright © 2018 Kartupelis, John. All rights reserved.
//

import Foundation
import XCTest
@testable import github_trending_ios

class GitHubParsersTest: XCTestCase {

    let repositoryParser = GitHubRepositoryParser()
    let readmeParser = GitHubReadmeParser()

    func testParsesGoodRepositoriesResponse() {
        let data = getDataFromFile(forClass: type(of: self), withName: "good_repositories_response", andExtension: "json")
        guard let fileData = data else {
            XCTFail("Cannot find good repositories response")
            return
        }
        let repositories = repositoryParser.parseResponseData(data: fileData)
        XCTAssertEqual(1, repositories?.count)

        let repositoryFirst = repositories?[0]
        XCTAssertEqual(122692377, repositoryFirst?.id)
        XCTAssertEqual(1390, repositoryFirst?.forksCount)
        XCTAssertEqual("houshanren", repositoryFirst?.owner.name)
    }

    func testFailsToParseBadRepositoriesResponse() {
        let data = getDataFromFile(forClass: type(of: self), withName: "bad_repositories_response", andExtension: "json")
        guard let fileData = data else {
            XCTFail("Cannot find good repositories response")
            return
        }
        let repositories = repositoryParser.parseResponseData(data: fileData)
        XCTAssertEqual(0, repositories?.count)
    }

    func testParsesGoodReadmeResponse() {
        let data = getDataFromFile(forClass: type(of: self), withName: "good_readme_response", andExtension: "json")
        guard let fileData = data else {
            XCTFail("Cannot find good repositories response")
            return
        }
        let readme = readmeParser.parseResponseData(data: fileData)
        XCTAssertNotNil(readme)
        XCTAssertEqual("This is a test README.md", readme?.readmeMarkdown)
    }

    func testFailsToParseBadReadmeResponse() {
        let data = getDataFromFile(forClass: type(of: self), withName: "bad_readme_response", andExtension: "json")
        guard let fileData = data else {
            XCTFail("Cannot find good repositories response")
            return
        }
        let readme = readmeParser.parseResponseData(data: fileData)
        XCTAssertNil(readme)
    }
}
