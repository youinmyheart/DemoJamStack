// 
// LoginViewModel.swift
// 
// Created on 6/20/20.
//

struct LoginViewModel {

    var email: String? = ""
    var isEmailValid: Bool {
        AppUtils.isValidEmail(email)
    }
    
    var password: String? = ""
    var isPasswordValid: Bool {
        if let pass = password {
            return pass.count >= 6
        } else {
            return false
        }
    }
    
    var emailErrorStr: String {
        if email?.count == 0 {
            return Constants.enterEmail
        } else {
            return isEmailValid ? "" : Constants.emailInvalid
        }
    }
    
    var passwordErrorStr: String {
        if password?.count == 0 {
            return Constants.enterPassword
        } else {
            return isPasswordValid ? "" : Constants.passwordInvalid
        }
    }
}
