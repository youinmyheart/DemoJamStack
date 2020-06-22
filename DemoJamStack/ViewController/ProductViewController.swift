//
//  ProductViewController.swift
//  DemoJamStack
//
//  Created on 6/22/20.
//

import UIKit

class ProductViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtils.log("viewDidLoad")
        setUpNavigation(title: "Product")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
    }
}
