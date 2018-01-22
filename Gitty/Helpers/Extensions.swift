//
//  Extensions.swift
//  Gitty
//
//  Created by upandrarai on 20/01/18.
//  Copyright © 2018 Kunal. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: self)
        guard let dateValue = date else {
            return ""
            
        }
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: dateValue)
    }
    
    func containsIgnoringCase(_ find: String) -> Bool {
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}

func storyBoardWithID(_ name: String) -> UIStoryboard {
    return UIStoryboard(name: name, bundle: nil)
}

extension UIStoryboard {
    func viewControllerWithID(_ name: String) -> UIViewController {
        return self.instantiateViewController(withIdentifier: name)
    }
}

extension Optional where Wrapped == Int {
    var stringValue : String {
        guard let value = self else {
            return "0"
        }
        return "\(value)"
    }
    var nsNumber : Int64 {
        guard let value = self else {
            return Int64(exactly: NSNumber(value: 0))!
        }
        return Int64(exactly: NSNumber(value: value))!
    }
}

extension Optional where Wrapped == String {
    func containsIgnoringCase(_ find: String) -> Bool {
        guard let value = self else { return false }
        return value.range(of: find, options: .caseInsensitive) != nil
    }
}

extension UITableViewCell {
    func animateCell() {
        self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.4) {
            self.transform = CGAffineTransform.identity
        }
    }
}

func isInternetAvailable() -> Bool {
    
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        }
    }) else {
        return false
    }
    
    var flags: SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
        return false
    }
    
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    
    return (isReachable && !needsConnection)
}
