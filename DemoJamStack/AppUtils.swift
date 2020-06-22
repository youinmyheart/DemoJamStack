// 
// AppUtils.swift
// 
// Created on 2/29/20.
// 

import UIKit
import NVActivityIndicatorView

class AppUtils: NSObject {

    public class func isEmptyString(_ str: String?) -> Bool {
        return (str ?? "").isEmpty
    }
    
    public class func log(_ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line ) {
        #if DEBUG
        let className = file.components(separatedBy: "/").last
        var str = ""
        
        for (index, item) in items.enumerated() {
            str += String(describing: item)
            if index < items.count - 1 {
                str += separator
            }
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        let dateTime = formatter.string(from: Date())
        
        print("\(dateTime) [\(className ?? "")] [Line \(line)]", str, separator: separator, terminator: terminator)
        #endif
    }
    
    public static func getPreviousMonth() -> String {
        let prevMonthStr: String
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date()) {
            prevMonthStr = formatter.string(from: previousMonth)
        } else {
            // in case error, we get current date
            prevMonthStr = formatter.string(from: Date())
        }
        return prevMonthStr
    }
    
    public static func getDateString(from str: String?) -> String {
        // "2020-02-29T00:32:00Z" -> "2020-02-29 07:32:00"
        guard let str = str else { return "" }
        var ret = str
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let date = dateFormatter.date(from:str) {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            ret = dateFormatter.string(from: date)
        }
        return ret
    }
    
    public static func attributedString(mainStr: String, stringToColor: String, color: UIColor) -> NSAttributedString {
        let range = (mainStr as NSString).range(of: stringToColor)
        let attribute = NSMutableAttributedString.init(string: mainStr)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: range)
        return attribute
    }
    
    public static func isValidEmail(_ email: String?) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
    
    public class func showAlert(title: String?, message: String?, buttonStr: String?, viewController: UIViewController, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let okBtn = UIAlertAction.init(title: buttonStr, style: .default, handler: handler)
        alert.addAction(okBtn)
        viewController.present(alert, animated: true)
    }
    
    public class func showAlert(title: String?, message: String?, buttonStr1: String?, buttonStr2: String?, viewController: UIViewController, handler1: ((UIAlertAction) -> Void)? = nil, handler2: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let okBtn = UIAlertAction.init(title: buttonStr1, style: .default, handler: handler1)
        let cancelBtn = UIAlertAction.init(title: buttonStr2, style: .default, handler: handler2)
        alert.addAction(okBtn)
        alert.addAction(cancelBtn)
        viewController.present(alert, animated: true)
    }
    
    public static func startAnimating() {
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    public static func stopAnimating() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
    public static func isAnimating() -> Bool {
        NVActivityIndicatorPresenter.sharedInstance.isAnimating
    }
    
    public static func navigationBarColor() -> UIColor {
        return UIColor(red: 0/255, green: 147/255, blue: 241/255, alpha: 1)
    }
    
    public static func setNavigationTitle(text: String, width: CGFloat, navItem: UINavigationItem) {
        // nav title left align
        let container = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 44))
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 0, width: width, height: 44)
        label.text = text
        label.textColor = .white
        container.addSubview(label)
        navItem.titleView = container
    }
}
