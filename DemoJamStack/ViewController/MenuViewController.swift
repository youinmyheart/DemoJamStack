// 
// MenuViewController.swift
// 
// Created on 6/21/20.
// 

import UIKit

protocol MenuViewControllerDelegate: class {
    func didTapButtonDismiss()
}

class MenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnDismiss: UIButton!
    
    var menuVM = MenuViewModel()
    weak var delegate: MenuViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtils.log("viewDidLoad")
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    @IBAction func tapBtnDismiss(_ sender: Any) {
        delegate?.didTapButtonDismiss()
    }
    
    private func setUpView() {
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "ProfileHeaderTableCell", bundle: nil), forCellReuseIdentifier: ProfileHeaderTableCell.cellId)
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuVM.numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuVM.numOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileHeaderTableCell.cellId, for: indexPath) as! ProfileHeaderTableCell
            cell.lblName.text = menuVM.name
            cell.lblGender.text = menuVM.genderStr
            cell.selectionStyle = .none
            return cell
            
        case 1:
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            }
            cell?.textLabel?.text = menuVM.titleForRow(indexPath.row)
            return cell!
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 1 {
            return nil
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height))
        view.backgroundColor = .black
        view.alpha = 0.1
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
