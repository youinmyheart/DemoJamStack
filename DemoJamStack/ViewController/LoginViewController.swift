// 
// LoginViewController.swift
// 
// Created on 6/19/20.
// 

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblEmailGuide: UILabel!
    @IBOutlet weak var lblPasswordGuide: UILabel!
    
    private var loginVM = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtils.log("viewDidLoad")
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        registerKeyboardNoti()
        textFieldPassword.text = ""
    }

    @IBAction func tapOnBtnSignUp(_ sender: Any) {
        AppUtils.log("tapOnBtnSignUp")
        view.endEditing(true)
        goToRegistrationVC()
    }
    
    @IBAction func tapOnBtnLogin(_ sender: Any) {
        AppUtils.log("tapOnBtnLogin")
        view.endEditing(true)
        logIn()
    }
    
    private func setUpView() {
        btnLogin.layer.cornerRadius = 5
        
        textFieldEmail.becomeFirstResponder()
        textFieldEmail.borderStyle = .roundedRect
        textFieldEmail.returnKeyType = .next
        textFieldEmail.keyboardType = .emailAddress
        
        textFieldPassword.borderStyle = .roundedRect
        textFieldPassword.returnKeyType = .done
        textFieldPassword.isSecureTextEntry = true
        
        textFieldEmail.delegate = self
        textFieldPassword.delegate = self
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func registerKeyboardNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        guard let userInfo = notification.userInfo else { return }
        
        guard let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        var keyboardFrame = value.cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification) {
        scrollView.contentInset = .zero
    }
    
    private func logIn() {
        loginVM.email = textFieldEmail.text
        loginVM.password = textFieldPassword.text
        if !loginVM.isEmailValid {
            lblEmailGuide.text = loginVM.emailErrorStr
            lblEmailGuide.textColor = .red
            return
        }
        lblEmailGuide.text = loginVM.emailErrorStr
        lblEmailGuide.textColor = .black
        
        if !loginVM.isPasswordValid {
            lblPasswordGuide.text = loginVM.passwordErrorStr
            lblPasswordGuide.textColor = .red
            return
        }
        lblPasswordGuide.text = loginVM.passwordErrorStr
        lblPasswordGuide.textColor = .black
        
        AppUtils.startAnimating()
        let params = ["email": loginVM.email, "password": loginVM.password]
        ApiHelper.logIn(params: params as [String : Any], completionSuccess: { (response) in
            AppUtils.stopAnimating()
            AppUtils.log("auth: \(String(describing: response.auth))")
            AppUtils.log("token: \(response.token ?? "")")
            self.goToProfileVC()
        }) { (error, dataStr) in
            AppUtils.stopAnimating()
            AppUtils.showAlert(title: Constants.error, message: Constants.logInError, buttonStr: Constants.ok, viewController: self)
            AppUtils.log("error: \(error.localizedDescription)")
            AppUtils.log("dataStr: \(dataStr ?? "")")
        }
    }
    
    private func goToProfileVC() {
        let vc = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func goToRegistrationVC() {
        let vc = RegistrationViewController(nibName: "RegistrationViewController", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldEmail {
            textField.resignFirstResponder()
            textFieldPassword.becomeFirstResponder()
        } else if textField == textFieldPassword {
            textField.resignFirstResponder()
            logIn()
        }
        return true
    }
}
