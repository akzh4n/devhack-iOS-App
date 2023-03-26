//
//  Validators.swift
//  devhack-iOS
//
//  Created by Акжан Калиматов on 25.03.2023.
//

import Foundation


class Validators {
    
    static func isFilledReg(name: String?, family: String?, middleName: String?, phonenumber: String?, password: String?) -> Bool {
        guard !(name ?? "").isEmpty,
              !(middleName ?? "").isEmpty,
              !(family ?? "").isEmpty,
            !(phonenumber ?? "").isEmpty,
            !(password ?? "").isEmpty
                else {
                return false
        }
        return true
    }
    
    
    static func isFilledLog(phonenumber: String?, password: String?) -> Bool {
        guard !(phonenumber ?? "").isEmpty,
            !(password ?? "").isEmpty
                else {
                return false
        }
        return true
    }
    
    static func isSimpleEmail(_ email: String) -> Bool {
        let emailRegEx = "^.+@.+\\..{2,}$"
        return check(text: email, regEx: emailRegEx)
    }
    
    private static func check(text: String, regEx: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: text)
    }
}
