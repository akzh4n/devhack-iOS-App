//
//  ApplicationModel.swift
//  devhack-iOS
//
//  Created by Акжан Калиматов on 26.03.2023.
//

import UIKit




struct ApplicationResponse: Decodable {
    var message: String
    var applications: ApplicationData
    var ok: Bool
}


struct ApplicationData: Decodable {
    var id: Int?
    var user_id: Int?
    var title: String?
    var status: String?
    var date: String?
    var category: String?
    var price: Int?
    var executor: String?
    var description: String?

}

