//
//  Endpoints.swift
//
//
//  Created by Andria Inasaridze on 17.03.24.
//

import Foundation

public protocol EndPoints {
    var baseURL: String { get }
    var path: String { get }
    var parameter: [URLQueryItem] { get }
//    var headers: Headers { get }
    var method: HTTPMethod { get }
    
    func getUrl() -> URL?
}

extension EndPoints {
    func getUrl() -> URL? {
        var component = URLComponents()
        component.scheme = "https"
        component.host = baseURL
        component.path = path
        component.queryItems = parameter
        return component.url
    }
}

