//
//  HomeViewController.swift
//  DemoJamStack
//
//  Created on 6/22/20.
//

import UIKit

class HomeViewController: BaseViewController {

    @IBOutlet weak var lblName: UILabel!
    
    var homeVM = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtils.log("viewDidLoad")
        setUpNavigation(title: "Home")
        lblName.text = homeVM.name
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
    }
}
