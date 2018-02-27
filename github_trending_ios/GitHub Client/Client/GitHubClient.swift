//
//  GitHubClient.swift
//  github_trending_ios
//
//  Created by Kartupelis, John on 27/02/2018.
//  Copyright © 2018 Kartupelis, John. All rights reserved.
//

import Foundation
import ReactiveSwift

final class GitHubClient {

    let network: NetworkStack
    let baseURL: URL
    let dateFormatter: DateFormatter

    init(baseURL: URL, network: NetworkStack) {
        self.baseURL = baseURL
        self.network = network

        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }

    func getTrendingRepositories() -> SignalProducer<[GitHubRepository], GitHubError> {
        let fullURL = baseURL.appendingPathComponent("search").appendingPathComponent("repositories")

        let sevenDaysAgo = Date(timeIntervalSinceNow: -86400 * 7)
        let dateString = dateFormatter.string(from: sevenDaysAgo)

        let networkRequest = NetworkRequest(method: .get,
                                            url: fullURL,
                                            headers: [String: String](),
                                            queryParameters: ["sort": "stars",
                                                              "order": "desc",
                                                              "q":"created:>\(dateString)"])
        return network.makeNetworkRequest(request: networkRequest,
                                          responseParser: GitHubRepositoryParser(),
                                          errorParser: GitHubErrorParser())
    }

    func getReadmeForRepository(repository: GitHubRepository) -> SignalProducer<GitHubReadme, GitHubError> {
        let fullURL = baseURL.appendingPathComponent("repos")
                                .appendingPathComponent(repository.owner.name)
                                .appendingPathComponent(repository.name)
                                .appendingPathComponent("readme")
        let request = NetworkRequest(method: .get,
                                            url: fullURL,
                                            headers: [String: String](),
                                            queryParameters: [String: String]())
        return network.makeNetworkRequest(request: request,
                                          responseParser: GitHubReadmeParser(),
                                          errorParser: GitHubErrorParser())
    }
}
