// 
// RegistrationViewController.swift
// 
// Created on 6/20/20.
// 

import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnLogIn: UIButton!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var lblPassword: UILabel!
    
    @IBOutlet weak var textFieldGender: UITextField!
    @IBOutlet weak var imvDropdown: UIImageView!
    @IBOutlet weak var btnGender: UIButton!
    @IBOutlet weak var lblGender: UILabel!
    
    @IBOutlet weak var textFieldAge: UITextField!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var btnRegister: UIButton!
    
    private var registrationVM = RegistrationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtils.log("viewDidLoad")
        setUpView()
        registerKeyboardNoti()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func tapBtnGender(_ sender: Any) {
        AppUtils.log("tapBtnGender")
        showGenderAlert()
    }
    
    @IBAction func tapBtnLogin(_ sender: Any) {
        AppUtils.log("tapBtnLogin")
        goBackToLoginVC()
    }
    
    @IBAction func tapBtnRegister(_ sender: Any) {
        AppUtils.log("tapBtnRegister")
        registerAccount()
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func setUpView() {
        let barBtn = UIBarButtonItem(image: UIImage(named: "icon_back"), style: .plain, target: self, action: #selector(self.tapBack))
        navigationItem.leftBarButtonItem = barBtn
        // nav background color
        navigationController?.navigationBar.barTintColor = .white
        // nav icon color
        navigationController?.navigationBar.tintColor = .black
        // remove nav border
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        btnRegister.layer.cornerRadius = 5
        
        textFieldName.becomeFirstResponder()
        textFieldName.borderStyle = .roundedRect
        textFieldName.returnKeyType = .next
        
        textFieldEmail.borderStyle = .roundedRect
        textFieldEmail.returnKeyType = .next
        textFieldEmail.keyboardType = .emailAddress
        
        textFieldPassword.borderStyle = .roundedRect
        textFieldPassword.returnKeyType = .next
        textFieldPassword.isSecureTextEntry = true
        
        textFieldGender.borderStyle = .roundedRect
        textFieldGender.isUserInteractionEnabled = false
        
        textFieldAge.borderStyle = .roundedRect
        textFieldAge.returnKeyType = .done
        textFieldAge.keyboardType = .numberPad
        
        textFieldName.delegate = self
        textFieldEmail.delegate = self
        textFieldPassword.delegate = self
        textFieldAge.delegate = self
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(tapGesture)
        AppUtils.log("content size: \(scrollView.contentSize)")
    }
    
    @objc func tapBack() {
        AppUtils.log("tapBack")
        goBackToLoginVC()
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
    
    private func goBackToLoginVC() {
        navigationController?.popViewController(animated: true)
    }
    
    private func showGenderAlert() {
        AppUtils.showAlert(title: "Select Gender", message: "Please choose your gender", buttonStr1: "Male", buttonStr2: "Female", viewController: self, handler1: { (action) in
            self.textFieldGender.text = "Male"
            self.registrationVM.genderStr = self.textFieldGender.text
            if self.textFieldAge.text == "" {
                self.textFieldAge.becomeFirstResponder()
            }
        }) { (action) in
            self.textFieldGender.text = "Female"
            self.registrationVM.genderStr = self.textFieldGender.text
            if self.textFieldAge.text == "" {
                self.textFieldAge.becomeFirstResponder()
            }
        }
    }
    
    private func registerAccount() {
        registrationVM.name = textFieldName.text
        registrationVM.email = textFieldEmail.text
        registrationVM.password = textFieldPassword.text
        registrationVM.ageStr = textFieldAge.text
        
        if !registrationVM.isNameValid {
            lblName.text = registrationVM.nameErrorStr
            lblName.textColor = .red
            return
        }
        lblName.text = registrationVM.nameErrorStr
        lblName.textColor = .black
        
        if !registrationVM.isEmailValid {
            lblEmail.text = registrationVM.emailErrorStr
            lblEmail.textColor = .red
            return
        }
        lblEmail.text = registrationVM.emailErrorStr
        lblEmail.textColor = .black
        
        if !registrationVM.isPasswordValid {
            lblPassword.text = registrationVM.passwordErrorStr
            lblPassword.textColor = .red
            return
        }
        lblPassword.text = registrationVM.passwordErrorStr
        lblPassword.textColor = .black
        
        AppUtils.startAnimating()
        let params = ["name": registrationVM.name ?? "", "email": registrationVM.email ?? "", "password": registrationVM.password ?? "", "gender": registrationVM.gender, "age": registrationVM.age] as [String : Any]
        ApiHelper.register(params: params, completionSuccess: { (response) in
            AppUtils.stopAnimating()
            AppUtils.log("auth: \(String(describing: response.auth))")
            AppUtils.log("token: \(response.token ?? "")")
            self.goToProfileVC(token: response.token)
        }) { (error, dataStr) in
            AppUtils.stopAnimating()
            AppUtils.showAlert(title: Constants.error, message: "Can't create this user. Please contact your administrator", buttonStr: Constants.ok, viewController: self)
            AppUtils.log("error: \(error.localizedDescription)")
            AppUtils.log("dataStr: \(dataStr ?? "")")
        }
    }
    
    private func goToProfileVC(token: String?) {
        AppUtils.log("goToProfileVC")
        let vc = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        if let token = token {
            vc.profileVM.token = token
        }
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func disableMenu() {
        self.navigationController?.navigationBar.gestureRecognizers?.removeAll()
        self.navigationController?.view.gestureRecognizers?.removeAll()
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldName {
            textField.resignFirstResponder()
            textFieldEmail.becomeFirstResponder()
        } else if textField == textFieldEmail {
            textField.resignFirstResponder()
            textFieldPassword.becomeFirstResponder()
        } else if textField == textFieldPassword {
            textField.resignFirstResponder()
            showGenderAlert()
        }
        return true
    }
}

extension RegistrationViewController: ProfileViewControllerDelegate {
    func didTapLogout() {
        AppUtils.log("didTapLogout")
        disableMenu()
    }
}
