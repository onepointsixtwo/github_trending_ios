//
//  NetworkStack.swift
//  github_trending_ios
//
//  Created by Kartupelis, John on 27/02/2018.
//  Copyright © 2018 Kartupelis, John. All rights reserved.
//

import Foundation
import ReactiveSwift

enum HttpMethod {
    case get
}

class NetworkRequest {
    let method: HttpMethod
    let url: URL
    let headers: [String: String]
    let queryParameters: [String: String]

    init(method: HttpMethod, url: URL, headers: [String: String], queryParameters: [String: String]) {
        self.method = method
        self.url = url
        self.headers = headers
        self.queryParameters = queryParameters
    }
}

protocol ResponseParseable {
    associatedtype T

    func parseResponseData(data: Data) -> T
}

protocol ErrorParseable {
    associatedtype E: Error

    func parseError(error: Error?) -> E
}

protocol NetworkStack {

    func makeNetworkRequest<R: ResponseParseable, E: ErrorParseable>(request: NetworkRequest, responseParser: R, errorParser: E) -> SignalProducer<R.T, E.E>
}
