//
//  ServiceData.swift
//  devhack-iOS
//
//  Created by Акжан Калиматов on 26.03.2023.
//

import UIKit





struct ServiceResponse: Decodable {
    var message: String
    var services: ServiceData
    var ok: Bool
}


struct ServiceData: Decodable {
    var id: Int?
    var description: String?
    var category: String?
    var price: Int?
    var time_to_complete: String?
    var name: String?

}
