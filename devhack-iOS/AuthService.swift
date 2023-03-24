//
//  AuthService.swift
//  devhack-iOS
//
//  Created by Акжан Калиматов on 24.03.2023.
//

import Foundation
import Alamofire
import KeychainSwift

class AuthService {
    static let shared = AuthService()
    let baseURL = "https://startoryx.live/"
    
    let keychain = KeychainSwift()
    
    
    //    MARK: - AUTH USER
    
    func authenticateUser(phoneNumber: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let authEndpoint = "\(baseURL)api/users/sendCode"
        let parameters = [
            "phone": phoneNumber
        ]
        
        AF.request(authEndpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    //    MARK: - VERIFY CODE
    
    func verifyCode(phoneNumber: String, name: String, verificationCode: String, deviceToken: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let verifyEndpoint = "\(baseURL)api/users/checkCode"
        let parameters: [String: Any] = [
            "phone": phoneNumber,
            "name" : name,
            "code": verificationCode,
            "deviceToken": deviceToken
        ]
        
        AF.request(verifyEndpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            print(response.result)
            switch response.result {
            case .success(let value):
                if let dict = value as? [String: Any],
                   let accessToken = dict["accessToken"] as? String,
                   let refreshToken = dict["refreshToken"] as? String, // save refresh token
                   let userDict = dict["user"] as? [String: Any],
                   let userId = userDict["id"] as? Int,
                   let phone = userDict["phone"] as? String,
                   let name = userDict["name"] as? String {
                    self.keychain.set(accessToken, forKey: "jwt_token")
                    self.keychain.set(refreshToken, forKey: "refresh_token") // save refresh token
                    self.keychain.set("\(userId)", forKey: "user_id")
                    self.keychain.set(phone, forKey: "user_phone")
                    self.keychain.set(name, forKey: "user_name")
                    completion(.success(()))
                } else {
                    completion(.failure(AuthError.invalidResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    //    MARK: - REFRESH ACCESS TOKENS
    
    func refreshAccessTokens(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let refreshToken = keychain.get("refresh_token") else {
            completion(.failure(AuthError.invalidResponse))
            return
        }
        
        let refreshEndpoint = "\(baseURL)api/users/refresh"
        let headers: HTTPHeaders = [
            "Cookie": "refreshToken=\(refreshToken)"
        ]
        
        print("RefreshToken: \(refreshToken)")
        
        AF.request(refreshEndpoint, method: .get, headers: headers).responseJSON { response in
            print("Refresh result: \(response.result)")
            switch response.result {
            case .success(let value):
               
                    if let dict = value as? [String: Any],
                    let accessToken = dict["accessToken"] as? String,
                    let refreshToken = dict["refreshToken"] as? String {
                    self.keychain.set(accessToken, forKey: "jwt_token")
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
           if let accessToken = keychain.get("jwt_token") {
               completion(.success(accessToken))
           } else {
               completion(.failure(AuthError.invalidResponse))
           }
       }
    
    
    
    //    MARK: - GET USER DATA
       
       func getUserData(completion: @escaping (Result<[String: Any], Error>) -> Void) {
           getAccessToken { [self] result in
               switch result {
               case .success(let accessToken):
                   let headers: HTTPHeaders = [
                    "Authorization": "Bearer \(accessToken)"
                   ]
                   
                   let getUserEndpoint = "\(baseURL)api/users/getMe"
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
    
    
    func deleteAllTokens() {
        keychain.delete("refresh_token")
        keychain.delete("jwt_token")
    }
    
    
    func deleteAll() {
        keychain.clear()
    }

    
    enum AuthError: Error {
        case validResponse
        case invalidResponse
    }
    
}
