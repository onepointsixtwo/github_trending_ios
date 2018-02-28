//
//  ObservableField.swift
//  github_trending_ios
//
//  Created by Kartupelis, John on 28/02/2018.
//  Copyright © 2018 Kartupelis, John. All rights reserved.
//

import Foundation

class ObservableField<T> {
    private var observer: ((T) -> ())?
    var value: T {
        didSet {
            observer?(value)
        }
    }

    init(value: T) {
        self.value = value
    }

    func observe(observer: @escaping (T) -> ()) {
        self.observer = observer
        observer(value)
    }
}
