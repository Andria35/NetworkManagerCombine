import Foundation
import Combine

public struct RequestModel {
    let endPoints: EndPoints
    let body: Data?
    let requestTimeOut: Float?
    
//    public init(endPoints: EndPoints,
//                reqBody: Encodable? = nil,
//                requestTimeOut: Float?) {
//        self.endPoints = endPoints
//        self.body = reqBody?.encode()
//        self.requestTimeOut = requestTimeOut
//    }
    
    public init(endPoints: EndPoints, body: Data? = nil, requestTimeOut: Float? = nil) {
        self.endPoints = endPoints
        self.body = body
        self.requestTimeOut = requestTimeOut
    }
    
    func getUrlRequest() -> URLRequest? {
        
        guard let url = endPoints.getUrl() else {
            print("URL not found")
            return nil
        }
        // create request
        var request: URLRequest = URLRequest(url: url)
        
        request.httpMethod = endPoints.method.rawValue
        
        return request
    }
}

@available(macOS 10.15, *)
public protocol APIServices {
    var requestTimeOut: Float { get }
    
    func request<T: Codable>(_ req: RequestModel) -> AnyPublisher<T, Error>
}

@available(macOS 10.15, *)
public class NetworkManagerCombine: APIServices {
    
    public var requestTimeOut: Float = 30
    
    public func request<T>(_ req: RequestModel) -> AnyPublisher<T, Error> where T : Codable {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = TimeInterval(req.requestTimeOut ?? requestTimeOut)
        
        guard let request = req.getUrlRequest() else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { (output) in
                
                guard output.response is HTTPURLResponse else {
                    throw NetworkError.serverError
                }
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                NetworkError.invalidJSON
            }
            .eraseToAnyPublisher()
    }
    
    
}

enum NetworkError: Error {
    case serverError
    case invalidJSON
    case invalidUrlRequest
}
