//
//  AuthManager.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-20.
//

import Foundation
import Firebase
import Combine

protocol AuthDelegate {
    func userAuthenticatedAndSynced(_ userData:UserDTO)
    func userAuthenticated()
    func userUnauthenticated()
}

class AuthManager:NSObject {
    
    enum AuthSessionType {
        case  returningUser
        case newUser(dto:UserCreateDTO)
    }
    
    static let shared = AuthManager()
    
    private var requests = Set<AnyCancellable>()
    
    private var authListener:AuthStateDidChangeListenerHandle?
    
    var delegate:AuthDelegate?
    
    var sessionType = AuthSessionType.returningUser
    
    
    private override init() {
        
    }
    
    func startListening() {
        stopListening()
        
        authListener = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.log("state changed - isAuthenticated:\(user != nil)")
            if let user = user {
                user.getIDTokenForcingRefresh(true, completion: { token, error in
                    if let token = token, error == nil {
                        NetworkManager.shared.authToken = token
                        self.userAuthenticated()
                    } else {
                        self.userUnauthenticated()
                    }
                })
            } else {
                
                self.userUnauthenticated()
            }
        }
    }
    
    func stopListening() {
        if let listener = authListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
    
    
    private func userAuthenticated() {
        self.delegate?.userAuthenticated()
        self.sync()
    }
    
    private func userUnauthenticated() {
        NetworkManager.shared.authToken = nil
        sessionType = .returningUser
        self.delegate?.userUnauthenticated()
        
    }
    
    private func sync() {
        syncUser { userDTO in
            self.syncComplete(userDTO)
        }
    }
    
    private func syncUser(completion: @escaping(_ user:UserDTO) -> ()) {
        switch sessionType {
        case .newUser(let dto):
            API.User.create(dto)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { state in
                    print("completion: \(state)")
                }, receiveValue: { response in
                    completion(response)
                })
                .store(in: &requests)
            break
        case .returningUser:
            API.User.get()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { state in
                    print("completion: \(state)")
                }, receiveValue: { response in
                    completion(response)
                })
                .store(in: &requests)
            break
        }
    }
    
    private func syncComplete(_ userData:UserDTO) {
        print("sync complete - delegate: \(self.delegate != nil)")
        self.delegate?.userAuthenticatedAndSynced(userData)
    }
    
}
