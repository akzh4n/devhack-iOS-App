//
//  AuthService.swift
//  devhack-iOS
//
//  Created by Акжан Калиматов on 24.03.2023.
//

import Foundation
import Alamofire
import KeychainSwift

import Alamofire
import KeychainSwift

enum AuthError: Error {
    case validResponse
    case invalidResponse
    case keychainError(status: OSStatus)
}

class AuthService {
    static let shared = AuthService()
    let baseURL = "https://devhack-api.13lab.tech"
    let keychain = KeychainSwift()
    
    // MARK: - LOGIN USER
    
    func loginUser(phoneNumber: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let loginEndpoint = "\(baseURL)/api/users/login"
        let parameters = [
            "phone": phoneNumber,
            "password": password
        ]
        
        AF.request(loginEndpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - REGISTER USER
    
    func registerUser(phoneNumber: String, name: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let registerEndpoint = "\(baseURL)/api/users/register"
        
        let parameters: [String: Any] = [
            "phone": phoneNumber,
            "password": password,
            "name": name
        ]
        
        AF.request(registerEndpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { [self] response in
            print(response.result)
            switch response.result {
            case .success(let value):
                if let dict = value as? [String: Any],
                   let userDict = dict["user"] as? [String: Any],
                   let accessToken = userDict["accessToken"] as? String,
                   let refreshToken = userDict["refreshToken"] as? String {
                       self.keychain.set(accessToken, forKey: "access_token") // save access token
                       self.keychain.set(refreshToken, forKey: "refresh_token") // save refresh token
                       completion(.success(()))
                } else {
                   completion(.failure(AuthError.invalidResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    //    MARK: - LOGOUT USER
    
    func logoutUser(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let refreshToken = keychain.get("refresh_token") else {
            print("There are no refreshToken")
            return
        }
        
        let logoutEndpoint = "\(baseURL)/api/users/logout"
        let headers: HTTPHeaders = [
            "Cookie": "refreshToken=\(refreshToken)"
        ]
        
        AF.request(logoutEndpoint, method: .get, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    
    
    
    //    MARK: - REFRESH ACCESS TOKENS
    
    func refreshAccessTokens(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let refreshToken = keychain.get("refresh_token") else {
            print("There are no refresh_token")
            return
        }
        
        let refreshEndpoint = "\(baseURL)/api/users/refresh"
        let headers: HTTPHeaders = [
            "Cookie": "refreshToken=\(refreshToken)"
        ]
        
        print("RefreshToken: \(refreshToken)")
        
        AF.request(refreshEndpoint, method: .get, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                
                if let dict = value as? [String: Any],
                   let accessToken = dict["accessToken"] as? String,
                   let refreshToken = dict["refreshToken"] as? String {
                    self.keychain.set(accessToken, forKey: "access_token")
                    self.keychain.set(refreshToken, forKey: "refresh_token")
                    completion(.success(()))
                } else {
                    completion(.failure(AuthError.invalidResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //    MARK: - GET ACCESS TOKEN
    
    func getAccessToken(completion: @escaping (Result<String, Error>) -> Void) {
        if let accessToken = keychain.get("access_token") {
            completion(.success(accessToken))
            print(accessToken)
        } else {
            print("There are no access_token")
        }
    }
    
    
    
    //    MARK: - GET USER DATA
    
    func getUserData(completion: @escaping (Result<[String: Any], Error>) -> Void) {
        getAccessToken { [self] result in
            print(result)
            switch result {
            case .success(let accessToken):
                let headers: HTTPHeaders = [
                    "Authorization": "Bearer \(accessToken)"
                ]
                
                let getUserEndpoint = "\(baseURL)/api/users/getMe"
                AF.request(getUserEndpoint, method: .get, headers: headers).responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        print("Success when sending request: \(value)")
                        if response.response?.statusCode == 400  || response.response?.statusCode == 401 {
                            // Access token invalid, refresh it and try again
                            self.refreshAccessTokens { result in
                                switch result {
                                case .success:
                                    self.getUserData(completion: completion)
                                case .failure(let error):
                                    completion(.failure(error))
                                }
                            }
                        }
                    case .failure(let error):
                        print("Error when sending request: \(error)")
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    
    
    func isUserAuthenticated() -> Bool {
        return KeychainSwift().get("access_token") != nil
    }
    
    
    func deleteAllTokens() {
        keychain.delete("refresh_token")
        keychain.delete("access_token")
    }
    
    
    func deleteAll() {
        keychain.clear()
    }
    
    
    
}
