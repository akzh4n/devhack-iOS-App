//
//  ApplicationNetworkServices.swift
//  devhack-iOS
//
//  Created by Акжан Калиматов on 26.03.2023.
//

import Foundation
import Alamofire
import KeychainSwift

import Alamofire
import KeychainSwift

enum ApplicationNetworkError: Error {
    case validResponse
    case invalidResponse
    case keychainError(status: OSStatus)
}

class ApplicationNetworkService {
    static let shared = ApplicationNetworkService()
    let baseURL = "https://devhack-api.13lab.tech"
    let keychain = KeychainSwift()
    
    
    
    
    // CREATE APPLICATION
    
    
    func createApplication(description: String, title: String, category: String, price: Int, status: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let createAppEndpoint = "\(baseURL)/api/applications/createApplication"
        guard let accessToken = keychain.get("access_token") else {
                  print("There are no refreshToken")
                  return
              }
        let parameters = [
            "title": title,
            "category": category,
            "price" : price,
            "status" : status
        ] as [String : Any]
        
        let headers: HTTPHeaders = [
            "Authorization" : "Bearer \(accessToken)"
        ]
        
        AF.request(createAppEndpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    
    // GET MY APPLICATION
    
    func getMyApplications(completion: @escaping (([ApplicationData]) -> ())) {
        guard let accessToken = keychain.get("access_token") else {
            print("There are no accessToken")
            return
        }
        
        let getMyAppEndpoint = "\(baseURL)/api/applications/getMyApplications"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        let request = AF.request(getMyAppEndpoint, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
        
        request.responseJSON { response in
            switch response.result {
            case .success(let data):
                guard let json = data as? [String: Any],
                      let applicationsJSON = json["applications"] as? [[String: Any]]
                else {
                    print("Error decoding JSON")
                    return
                }
                do {
                    let applicationsData = try JSONSerialization.data(withJSONObject: applicationsJSON, options: [])
                    let decoder = JSONDecoder()
                    let applications = try decoder.decode([ApplicationData].self, from: applicationsData)
                    completion(applications)
                } catch {
                    print("Error decoding ApplicationData: \(error)")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }


    }
    
 
    
   
    
    // CREATE PAYMENT
    
    func createPayment(title: String, category: String, price: String, completion: @escaping (Result<String, Error>) -> Void) {
        let createPayEndpoint = "\(baseURL)/api/payments/createPayment"
        guard let accessToken = keychain.get("access_token") else {
            print("There are no refreshToken")
            return
        }
        let parameters = [        "title" : title,        "category": category,        "price" : price    ]
        
        let headers: HTTPHeaders = [        "Authorization" : "Bearer \(accessToken)"    ]
        
        AF.request(createPayEndpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any], let payment = json["payment"] as? String {
                    completion(.success(payment))
                } else {
                    completion(.failure(NSError(domain: "Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unexpected response format"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    
    
    // GET FILTERED SERVICES
    
    func getMyFilteredServices(completion: @escaping (([ServiceData]) -> ())) {
        guard let accessToken = keychain.get("access_token") else {
            print("There are no accessToken")
            return
        }
        
        let getMyFilServicesEndpoint = "\(baseURL)/api/services/getServices"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        let request = AF.request(getMyFilServicesEndpoint, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
        
        request.responseJSON { response in
            print(response.result)
            switch response.result {
            case .success(let data):
                guard let json = data as? [String: Any],
                      let servicesJSON = json["services"] as? [[String: Any]]
                else {
                    print("Error decoding JSON")
                    return
                }
                do {
                    let servicesData = try JSONSerialization.data(withJSONObject: servicesJSON, options: [])
                    let decoder = JSONDecoder()
                    let services = try decoder.decode([ServiceData].self, from: servicesData)
                    completion(services)
                } catch {
                    print("Error decoding ServiceData: \(error)")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }


    }
    
    
}
    
