//
//  GithubEntityParsers.swift
//  github_trending_ios
//
//  Created by Kartupelis, John on 27/02/2018.
//  Copyright © 2018 Kartupelis, John. All rights reserved.
//

import Foundation

enum GitHubError: Error {
    case general
}

final class GitHubErrorParser: ErrorParseable {
    typealias E = GitHubError

    func parseError(error: Error?) -> GitHubError {
        return .general
    }
}

final class GitHubReadmeParser: ResponseParseable {
    typealias T = GitHubReadme

    func parseResponseData(data: Data) -> GitHubReadmeParser.T? {
        if let content = String(data: data, encoding: .utf8) {
            return GitHubReadme(readmeMarkdown: content)
        }
        return nil
    }
}

final class GitHubReadmeLinkParser: ResponseParseable {
    typealias T = GitHubReadmeLink

    func parseResponseData(data: Data) -> GitHubReadmeLink? {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                let urlString = json["download_url"] as? String,
                let url = URL(string: urlString) {
                return GitHubReadmeLink(downloadURL: url)
            }
        } catch {
            print("Failed to parse Github Readme link")
        }
        return nil
    }
}

final class GitHubRepositoryParser: ResponseParseable {
    typealias T = [GitHubRepository]

    func parseResponseData(data: Data) -> [GitHubRepository]? {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                return parseGithubRepositoriesFromJson(json: json)
            }
        } catch {
            print("Failed to parse GitHub Repositories")
        }

        return nil
    }

    func parseGithubRepositoriesFromJson(json: [String: Any]) -> [GitHubRepository]? {
        var repositories = [GitHubRepository]()

        if let repositoriesJSON = json["items"] as? [[String: Any]] {
            repositoriesJSON.forEach {
                if let repository = parseGithubRepositoryFromJson(json: $0) {
                    repositories.append(repository)
                }
            }
        }

        return repositories
    }

    func parseGithubRepositoryFromJson(json: [String: Any]) -> GitHubRepository? {
        if let id = json["id"] as? Int,
            let repoName = json["name"] as? String,
            let owner = parseOwnerFromJson(json: (json["owner"] as? [String: Any])!),
            let description = json["description"] as? String,
            let forksURLString = json["forks_url"] as? String,
            let stargazersURLString = json["stargazers_url"] as? String,
            let forksURL = URL(string: forksURLString),
            let stargazersURL = URL(string: stargazersURLString),
            let stargazersCount = json["stargazers_count"] as? Int,
            let forksCount = json["forks_count"] as? Int {
            return GitHubRepository(id: id, name: repoName, owner: owner, description: description, forksURL: forksURL, stargazersURL: stargazersURL, forksCount: forksCount, stargazersCount: stargazersCount)
        }
        return nil
    }

    func parseOwnerFromJson(json: [String: Any]?) -> GitHubUser? {
        if let json = json,
            let name = json["login"] as? String,
            let id = json["id"] as? Int,
            let avatarURLString = json["avatar_url"] as? String,
            let avatarURL = URL(string: avatarURLString) {
            return GitHubUser(id: id, name: name, avatarURL: avatarURL)
        }
        return nil
    }
}
