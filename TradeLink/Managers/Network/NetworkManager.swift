//
//  NetworkManager.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-10.
//


import Foundation
import Combine

struct ServiceError: Decodable, Error {
    let statusCode:Int
}

class NetworkManager:NSObject, URLSessionDelegate {
    
    static let shared = NetworkManager()
    
    private let session: NetworkSession
    
    var authToken:String? {
        didSet {
            
            print("\n\n\(authToken ?? "No Token")\n\n")
        }
    }

    private override init() {
        self.session = URLSession.shared
        super.init()
        
    }
    
    // Perform unauthenticated request to url
    func request<Response:Decodable>(_ method:HTTPMethod = .GET,
                                     url:URL,
                                     body: Data?=nil,
                                     
                                     ofType type:Response.Type) -> AnyPublisher<Response, Error> {
        return self.session.publisher(method, for: url, body: body, token: self.authToken, ofType: type)
    }
    
    
    
    /*
        Convenience methods
     */
    
    // For convenience: perform unauthenticated request to endpoint
    func request<Response:Decodable>(_ method:HTTPMethod = .GET,
                                            _ endpoint: API.Endpoints,
                                            body: Data?=nil,
                                            ofType type:Response.Type) -> AnyPublisher<Response, Error> {
        let url = URL(string: API.hostURL + endpoint.str)!
        return request(method, url: url, body: body, ofType: type)
    }
    

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}
