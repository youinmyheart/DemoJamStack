//
//  HomeViewController.swift
//  DemoJamStack
//
//  Created on 6/22/20.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var lblName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtils.log("viewDidLoad")
    }

}
