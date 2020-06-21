// 
// MenuViewModel.swift
// 
// Created on 6/21/20.
//

struct MenuViewModel {

    var name: String? = ""
    var genderStr: String = ""
    
    var arrMenuItem = ["Home", "Products", "My Request", "Profile", "Logout"]
    
    var numOfSections: Int {
        return 2
    }
    
    func numOfRows(section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return arrMenuItem.count
        default:
            return 0
        }
    }
    
    func titleForRow(_ row: Int) -> String? {
        return arrMenuItem[row]
    }
}
