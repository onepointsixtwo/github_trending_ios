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

    public var data: Data?
    public var error: Bool = false

    public init() {}

    public func makeNetworkRequest<R, E>(request: NetworkRequest,
                                  responseParser: R,
                                  errorParser: E) -> SignalProducer<R.T, E.E> where R : ResponseParseable, E : ErrorParseable {
        if !error {
            return SignalProducer(value: responseParser.parseResponseData(data: data!)!)
        } else {
            return SignalProducer(error: errorParser.parseError(error: nil))
        }
    }
}

public func getDataFromFile(forClass: AnyClass, withName: String, andExtension: String) -> Data? {
    let bundle = Bundle(for: forClass)
    let path = bundle.path(forResource: withName, ofType: andExtension)!
    let data = NSData(contentsOfFile: path) as Data?
    return data
}
