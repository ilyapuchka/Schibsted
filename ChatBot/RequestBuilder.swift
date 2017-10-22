//
//  RequestBuilder.swift
//  ChatBot
//
//  Created by Ilya Puchka on 22/10/2017.
//  Copyright © 2017 Schibsted. All rights reserved.
//

import Foundation

protocol Buildable {}

extension Buildable {
    func with(_ block: (inout Self) -> Void) -> Self {
        var copy = self
        block(&copy)
        return copy
    }
}

extension URLComponents: Buildable {}

func request(_ components: URLComponents) -> URLRequest {
    return URLRequest(url: components.with {
        $0.scheme = "https"
        $0.host = "s3-eu-west-1.amazonaws.com"
        $0.path = "/rocket-interview".appending(components.path)
        }.url!)
}
