// 
// ProfileViewController.swift
// 
// Created on 6/20/20.
// 

import UIKit
import SideMenu

class ProfileViewController: UIViewController {

    var profileVM = ProfileViewModel()
    var leftMenu: SideMenuNavigationController!
    private var menuVC: MenuViewController!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtils.log("viewDidLoad")
        setUpView()
        getInfo()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationItem.hidesBackButton = true
    }
    
    @objc func tapMenu() {
        AppUtils.log("tapMenu")
        showMenu()
    }
    
    private func setUpView() {
        let barBtn = UIBarButtonItem(image: UIImage(named: "menu_dot"), style: .plain, target: self, action: #selector(self.tapMenu))
        navigationItem.rightBarButtonItem = barBtn
        //navigationItem.title = "My Profile"
        // nav background color
        navigationController?.navigationBar.barTintColor = AppUtils.navigationBarColor()
        // nav title color
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        // nav icon color
        navigationController?.navigationBar.tintColor = .white
        
        // nav title left align
        let container = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 0, width: view.frame.width, height: 44)
        label.text = "My Profile"
        label.textColor = .white
        container.addSubview(label)
        navigationItem.titleView = container
        
        var settings = SideMenuSettings()
        settings.menuWidth = view.frame.width
        
        menuVC = MenuViewController(nibName: "MenuViewController", bundle: nil)
        menuVC.delegate = self
        
        leftMenu = SideMenuNavigationController(rootViewController: menuVC, settings: settings)
        leftMenu.statusBarEndAlpha = 0
        leftMenu.presentationStyle = .menuSlideIn
        leftMenu.menuWidth = UIScreen.main.bounds.width
        
        SideMenuManager.default.leftMenuNavigationController = leftMenu
        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
    }
    
    private func getInfo() {
        AppUtils.startAnimating()
        ApiHelper.getInfo(token: profileVM.token, completionSuccess: { (response) in
            AppUtils.stopAnimating()
            self.handleInfoResponse(response)
        }) { (error, dataStr) in
            AppUtils.log("error: \(error.localizedDescription)")
            AppUtils.log("dataStr: \(dataStr ?? "")")
            AppUtils.stopAnimating()
            self.handleInfoResponse(nil)
        }
    }
    
    private func handleInfoResponse(_ response: InfoResponse?) {
        AppUtils.log("name: \(String(describing: response?.name))")
        AppUtils.log("email: \(String(describing: response?.email))")
        AppUtils.log("gender: \(String(describing: response?.gender))")
        AppUtils.log("age: \(String(describing: response?.age))")
        AppUtils.log("id: \(String(describing: response?.id))")
        profileVM.name = response?.name
        profileVM.email = response?.email
        profileVM.gender = response?.gender
        profileVM.age = response?.age
        
        lblName.text = profileVM.name
        lblEmail.text = profileVM.email
        lblAge.text = profileVM.ageStr
        lblGender.text = profileVM.genderStr
        
        menuVC.menuVM.name = profileVM.name
        menuVC.menuVM.genderStr = profileVM.genderStr
    }
    
    private func showMenu() {
        present(leftMenu, animated: true, completion: nil)
    }
    
    private func dismissMenu() {
        dismiss(animated: true, completion: nil)
    }
    
    private func handleMenuItem(at indexPath: IndexPath) {
        if indexPath.section != 1 {
            return
        }
        
        dismissMenu()
        switch indexPath.row {
        case 0:
            // Home
            break
        case 1:
            // Product
            break
        case 2:
            // My Request
            break
        case 3:
            // already in Profile screen
            break
        case 4:
            // Logout
            goBackToLoginVC()
        default:
            break
        }
    }
    
    private func goBackToLoginVC() {
        navigationController?.popViewController(animated: true)
    }
    
    private func goToHomeVC() {
        let vc = RegistrationViewController(nibName: "HomeViewController", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func goToProductVC() {
        let vc = RegistrationViewController(nibName: "ProductViewController", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func goToMyRequestVC() {
        let vc = RegistrationViewController(nibName: "MyRequestViewController", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProfileViewController: MenuViewControllerDelegate {
    func didTapButtonDismiss() {
        AppUtils.log("didTapButtonDismiss")
        dismissMenu()
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        handleMenuItem(at: indexPath)
    }
}
