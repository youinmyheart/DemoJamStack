//
//  MyRequestViewController.swift
//  DemoJamStack
//
//  Created on 6/22/20.
//

import UIKit

class MyRequestViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtils.log("viewDidLoad")
        setUpNavigation(title: "My Request")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
    }
}
