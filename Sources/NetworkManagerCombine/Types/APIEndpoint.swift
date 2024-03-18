//
//  APIEndpoint.swift
//  
//
//  Created by Andria Inasaridze on 18.03.24.
//

import Foundation

public protocol APIEndpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
}
