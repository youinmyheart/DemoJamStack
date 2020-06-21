// 
// ProfileViewModel.swift
// 
// Created on 6/21/20.
//

struct ProfileViewModel {

    var token: String = ""
    
    var name: String? = ""
    var email: String? = ""
    
    var age: Int? = 0
    var ageStr: String {
        if let num = age {
            return "\(num) years"
        }
        return ""
    }
    
    var gender: Int?
    var genderStr: String {
        if let value = gender {
            return value == 0 ? "Male" : "Female"
        }
        return ""
    }
}
