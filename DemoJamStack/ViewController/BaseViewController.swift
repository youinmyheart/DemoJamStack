//
//  BaseViewController.swift
//  DemoJamStack
//
//  Created on 6/22/20.
//

import UIKit
import SideMenu

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setUpNavigation(title: String) {
        let barBtn = UIBarButtonItem(image: UIImage(named: "menu_dot"), style: .plain, target: self, action: #selector(self.tapMenu))
        navigationItem.rightBarButtonItem = barBtn
        // nav background color
        navigationController?.navigationBar.barTintColor = AppUtils.navigationBarColor()
        // nav title color
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        // nav icon color
        navigationController?.navigationBar.tintColor = .white
        
        AppUtils.setNavigationTitle(text: title, width: view.frame.width, navItem: navigationItem)
    }
    
    @objc func tapMenu() {
        AppUtils.log("tapMenu")
        showMenu()
    }
    
    func showMenu() {
        if let menu = SideMenuManager.default.leftMenuNavigationController {
            present(menu, animated: true, completion: nil)
        }
    }
    
    func dismissMenu() {
        dismiss(animated: true, completion: nil)
    }
}
