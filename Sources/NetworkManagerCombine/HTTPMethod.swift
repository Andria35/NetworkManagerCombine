//
//  HTTPMethod.swift
//
//
//  Created by Andria Inasaridze on 17.03.24.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public enum Environment: String, CaseIterable {
    case development
    case staging
    case production
}
