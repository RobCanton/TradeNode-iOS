//
//  Authenticator.swift
//  OneTeam
//
//  Created by Robert Canton on 2020-11-11.
//

/*
import Foundation
import Combine

struct Token: Decodable {
  let tokenStr: String
}


enum AuthenticationError: Error {
  case loginRequired
}

class Authenticator:NSObject {
    private let session: NetworkSession
    private let queue = DispatchQueue(label: "Authenticator.\(UUID().uuidString)")
    
    private struct Keys {
        static let authToken = "auth_token"
    }
    
    var currentToken: Token? {
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: Keys.authToken) {
            self.log(message: "currentToken:\n\n\(token)\n")
            return Token(tokenStr: token)
        }
        
        return nil
    }
    
    func setAuthToken(_ token:Token?) {
        let defaults = UserDefaults.standard
        defaults.setValue(token?.tokenStr, forKey: Keys.authToken)
        
        if token != nil {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Constants.Notifications.userAuthenticated, object: nil)
            }
        } else {
            defaults.removeObject(forKey: Keys.authToken)
        }
    }
    
    // shared publisher for all refresh token requests
    private var refreshPublisher: AnyPublisher<Token, Error>?
    
    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }
    
    func validToken(forceRefresh: Bool = false) -> AnyPublisher<Token, Error> {
        print("validToken forceRefresh \(forceRefresh)")
      return queue.sync { [weak self] in
        // Scenario 1: token is currently being refresh,
        // return existing publisher
         
        if let publisher = self?.refreshPublisher {
            self?.log(message: "refreshToken Scenario 1")
          return publisher
        }

        // Scenario 2: no token, fail and logout
        guard let token = self?.currentToken else {
            self?.log(message: "refreshToken Scenario 2")
          return Fail(error: AuthenticationError.loginRequired)
            .eraseToAnyPublisher()
        }
        
        // Scenario 3: we already have a token and don't want to force a refresh
        if !forceRefresh {
            self?.log(message: "refreshToken Scenario 3")
            return Just(token)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        self?.log(message: "refreshToken Scenario 4")
        // Scenario 4: request token refresh from server
        let url = URL(string: Constants.host + Constants.Endpoint.refreshToken.str)!
        
        struct TokenRefreshResponse:Codable {
            let new_token:String
        }
        
        let publisher = session.publisher(.POST,
                                          for: url,
                                          body: nil,
                                          ofType: TokenRefreshResponse.self,
                                          token: currentToken)
            .share()
            .map({ return Token(tokenStr: $0.new_token) })
            .handleEvents(receiveOutput: { token in
                self?.setAuthToken(token)
            }, receiveCompletion: { _ in
                self?.queue.sync {
                    self?.refreshPublisher = nil
                }
            })
            .tryCatch({ error -> AnyPublisher<Token, Error> in
                DispatchQueue.main.async {
                    NotificationCenter.default.post(Notification(name: Constants.Notifications.userUnauthenticated))
                }
                
                throw ServiceError(statusCode: 401)
            })
            .eraseToAnyPublisher()

        self?.refreshPublisher = publisher
        return publisher
      }
    }
    
}
*/
