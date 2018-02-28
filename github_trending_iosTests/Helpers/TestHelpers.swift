//
//  TestHelpers.swift
//  github_trending_iosTests
//
//  Created by Kartupelis, John on 27/02/2018.
//  Copyright © 2018 Kartupelis, John. All rights reserved.
//

import Foundation
import ReactiveSwift
@testable import github_trending_ios

final public class TestNetworkStack: NetworkStack {

    private var responseList: [Data] = [Data]()
    public var error: Bool = false

    public init() {}

    public func addResponse(data: Data?) {
        responseList.append(data!)
    }

    public func makeNetworkRequest<R, E>(request: NetworkRequest,
                                  responseParser: R,
                                  errorParser: E) -> SignalProducer<R.T, E.E> where R : ResponseParseable, E : ErrorParseable {
        if !error {
            return SignalProducer(value: responseParser.parseResponseData(data: pickOffNextResponse()!)!)
        } else {
            return SignalProducer(error: errorParser.parseError(error: nil))
        }
    }

    private func pickOffNextResponse() -> Data? {
        if responseList.count > 0 {
            let data = responseList[0]
            responseList.remove(at: 0)
            return data
        }
        return nil
    }
}

public func getDataFromFile(forClass: AnyClass, withName: String, andExtension: String) -> Data? {
    let bundle = Bundle(for: forClass)
    let path = bundle.path(forResource: withName, ofType: andExtension)!
    let data = NSData(contentsOfFile: path) as Data?
    return data
}
