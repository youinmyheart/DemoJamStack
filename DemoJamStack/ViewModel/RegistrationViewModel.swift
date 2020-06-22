// 
// RegistrationViewModel.swift
// 
// Created on 6/23/20.
// 

import UIKit

struct RegistrationViewModel {
    
    var name: String? = ""
    var isNameValid: Bool {
        return !AppUtils.isEmptyString(name)
    }

    var email: String? = ""
    var isEmailValid: Bool {
        return AppUtils.isValidEmail(email)
    }
    
    var password: String? = ""
    var isPasswordValid: Bool {
        if let pass = password {
            return pass.count >= 6
        } else {
            return false
        }
    }
    
    var nameErrorStr: String {
        if name?.count == 0 {
            return "Your Full Name"
        } else {
            return isNameValid ? "" : Constants.nameEmpty
        }
    }
    
    var emailErrorStr: String {
        if email?.count == 0 {
            return "Email Address"
        } else {
            return isEmailValid ? "" : Constants.emailInvalid
        }
    }
    
    var passwordErrorStr: String {
        if password?.count == 0 {
            return "Password"
        } else {
            return isPasswordValid ? "" : Constants.passwordInvalid
        }
    }
    
    var gender: Int {
        if genderStr == "Male" {
            return 0
        } else {
            return 1
        }
    }
    var genderStr: String? = ""
    
    var age: Int {
        return Int(ageStr ?? "0") ?? 0
    }
    var ageStr: String? = ""
}
