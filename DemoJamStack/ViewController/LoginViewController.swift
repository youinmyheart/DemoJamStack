// 
// LoginViewController.swift
// 
// Created on 6/19/20.
// 

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    private func setUpView() {
        textFieldEmail.borderStyle = .roundedRect
        textFieldPassword.borderStyle = .roundedRect
        textFieldEmail.returnKeyType = .next
        textFieldPassword.returnKeyType = .done
    }
}

extension LoginViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
