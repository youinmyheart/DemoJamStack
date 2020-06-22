// 
// ProfileViewController.swift
// 
// Created on 6/20/20.
// 

import UIKit
import SideMenu

protocol ProfileViewControllerDelegate: class {
    func didTapLogout()
}

class ProfileViewController: BaseViewController {

    var profileVM = ProfileViewModel()
    var leftMenu: SideMenuNavigationController!
    weak var delegate: ProfileViewControllerDelegate?
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
    
    private func setUpView() {
        setUpNavigation(title: "My Profile")
        
        var settings = SideMenuSettings()
        settings.menuWidth = view.frame.width
        
        menuVC = MenuViewController(nibName: "MenuViewController", bundle: nil)
        menuVC.delegate = self
        menuVC.menuVM.selectedIndex = 3
        
        leftMenu = SideMenuNavigationController(rootViewController: menuVC, settings: settings)
        leftMenu.statusBarEndAlpha = 0
        leftMenu.presentationStyle = .menuSlideIn
        leftMenu.menuWidth = UIScreen.main.bounds.width
        leftMenu.allowPushOfSameClassTwice = false
        
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
    
    private func handleMenuItem(at indexPath: IndexPath) {
        if indexPath.section != 1 {
            return
        }
        
        dismissMenu()
        switch indexPath.row {
        case 0:
            // Home
            goToHomeVC()
            break
        case 1:
            // Product
            goToProductVC()
            break
        case 2:
            // My Request
            goToMyRequestVC()
            break
        case 3:
            navigationController?.popToViewController(self, animated: false)
        case 4:
            // Logout
            delegate?.didTapLogout()
            goBackToLoginVC()
        default:
            break
        }
    }
    
    private func goBackToLoginVC() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func goToHomeVC() {
        navigationController?.popToViewController(self, animated: false)
        let vc = HomeViewController(nibName: "HomeViewController", bundle: nil)
        vc.homeVM.name = profileVM.name
        navigationController?.pushViewController(vc, animated: false)
    }
    
    private func goToProductVC() {
        navigationController?.popToViewController(self, animated: false)
        let vc = ProductViewController(nibName: "ProductViewController", bundle: nil)
        navigationController?.pushViewController(vc, animated: false)
    }
    
    private func goToMyRequestVC() {
        navigationController?.popToViewController(self, animated: false)
        let vc = MyRequestViewController(nibName: "MyRequestViewController", bundle: nil)
        navigationController?.pushViewController(vc, animated: false)
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
