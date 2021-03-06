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
    let readmeLinkParser = GitHubReadmeLinkParser()

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
        XCTAssertEqual("https://avatars0.githubusercontent.com/u/6621875?v=4", repositoryFirst?.owner.avatarURL.absoluteString)
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
        let data = getDataFromFile(forClass: type(of: self), withName: "readme_content", andExtension: "txt")
        guard let fileData = data else {
            XCTFail("Cannot find good repositories response")
            return
        }
        let readme = readmeParser.parseResponseData(data: fileData)
        XCTAssertNotNil(readme)
        XCTAssertEqual("This is a test README.md\n", readme?.readmeMarkdown)
    }

    func testParsesGoodReadmeLinkResponse() {
        let data = getDataFromFile(forClass: type(of: self), withName: "good_readme_url_response", andExtension: "json")
        guard let fileData = data else {
            XCTFail("Cannot find good repositories response")
            return
        }

        let readme = readmeLinkParser.parseResponseData(data: fileData)
        XCTAssertNotNil(readme)
        XCTAssertEqual("https://www.google.com", readme?.downloadURL.absoluteString)
    }

    func testFailsToParseBadReadmeLinkResponse() {
        let data = getDataFromFile(forClass: type(of: self), withName: "bad_readme_url_response", andExtension: "json")
        guard let fileData = data else {
            XCTFail("Cannot find good repositories response")
            return
        }
        let readme = readmeLinkParser.parseResponseData(data: fileData)
        XCTAssertNil(readme)
    }
}
