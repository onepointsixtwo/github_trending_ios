//
//  AlamoFireNetworkStack.swift
//  github_trending_ios
//
//  Created by Kartupelis, John on 27/02/2018.
//  Copyright © 2018 Kartupelis, John. All rights reserved.
//

import Alamofire
import Foundation
import ReactiveSwift

final class AlamofireNetworkStack: NetworkStack {

    private let sessionManager: SessionManager

    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }

    func makeNetworkRequest<R, E>(request: NetworkRequest, responseParser: R, errorParser: E) -> SignalProducer<R.T, E.E> where R : ResponseParseable, E : ErrorParseable {
        return SignalProducer { obs, _ in
            self.sessionManager.request(request.url,
                                        method: self.alamoFireHttpMethodFromHttpMethod(httpMethod: request.method),
                                        parameters: request.queryParameters,
                                        encoding: URLEncoding.default,
                                        headers: request.headers)
                .validate(statusCode: 200..<300)
                .responseData { (response: DataResponse) in
                    if let data = response.data {
                        obs.send(value: responseParser.parseResponseData(data: data))
                        obs.sendCompleted()
                    } else {
                        obs.send(error: errorParser.parseError(error: response.error))
                    }
                }
        }
    }

    private func alamoFireHttpMethodFromHttpMethod(httpMethod: HttpMethod) -> HTTPMethod  {
        // We currently only support get, so I've skipped on some currently
        // unnecessary logic
        return .get
    }
}
