//
//  FileNetworkSession.swift
//  ChatBotTests
//
//  Created by IIlya Puchka on 23.10.17.
//  Copyright © 2017 Schibsted. All rights reserved.
//

import Foundation
@testable import ChatBot

class FileNetworkSession: NetworkSession {
    var responses: [URLRequest: Any] = [:]
    var errors: [URLRequest: Error] = [:]
    
    func request<T: Decodable>(_ request: URLRequest, completion: @escaping (T?, Data?, HTTPURLResponse?, Error?) -> Void) {
        DispatchQueue.main.async {
            completion(self.responses[request] as? T, nil, nil, self.errors[request])
        }
    }
}
