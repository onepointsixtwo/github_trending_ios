//
//  GithubEntities.swift
//  github_trending_ios
//
//  Created by Kartupelis, John on 27/02/2018.
//  Copyright © 2018 Kartupelis, John. All rights reserved.
//

import Foundation

final class GitHubUser {
    let id: Int
    let name: String
    let avatarURL: URL

    init(id: Int,
         name: String,
         avatarURL: URL) {
        self.id = id
        self.name = name
        self.avatarURL = avatarURL
    }
}

final class GitHubRepository {
    let id : Int
    let name: String
    let owner: GitHubUser
    let description: String
    let forksURL : URL
    let stargazersURL: URL
    let forksCount: Int
    let stargazersCount: Int

    init(id: Int,
         name: String,
         owner: GitHubUser,
         description: String,
         forksURL: URL,
         stargazersURL: URL,
         forksCount: Int,
         stargazersCount: Int) {
        self.id = id
        self.name = name
        self.owner = owner
        self.description = description
        self.forksURL = forksURL
        self.stargazersURL = stargazersURL
        self.forksCount = forksCount
        self.stargazersCount = stargazersCount
    }
}

final class GitHubReadme {
    let readmeMarkdown: String

    init(readmeMarkdown: String) {
        self.readmeMarkdown = readmeMarkdown
    }
}

final class GitHubReadmeLink {
    let downloadURL: URL

    init(downloadURL: URL) {
        self.downloadURL = downloadURL
    }
}
