//
//  InitialViewController.swift
//  Gitty
//
//  Created by upandrarai on 20/01/18.
//  Copyright © 2018 Kunal. All rights reserved.
//

import UIKit
import Alamofire
import SkyFloatingLabelTextField
import SwiftyJSON
import UIView_Shake

class ViewController: UIViewController {
    
    @IBOutlet weak var userNameField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        guard let userName = userNameField.text, userName.isEmpty == false else {
            userNameField.lineColor = UIColor.red
            userNameField.titleColor = UIColor.red
            userNameField.shake(10, withDelta: 5) {
                self.userNameField.lineColor = UIColor.black
                self.userNameField.titleColor = UIColor.black
            }
            return
        }
        guard let password = passwordField.text, password.isEmpty == false else {
            passwordField.lineColor = UIColor.red
            passwordField.titleColor = UIColor.red
            passwordField.shake(10, withDelta: 5) {
                self.passwordField.lineColor = UIColor.black
                self.passwordField.titleColor = UIColor.black
            }
            return
        }
        
        loginWithUsername(userName, password: password)
        
    }
    
    func loginWithUsername(_ username: String, password: String) {
        self.view.endEditing(true)
        var basicAuth = ""
        let optData = "\(username):\(password)".data(using: String.Encoding.utf8)
        if let data = optData {
            basicAuth = "Basic \(data.base64EncodedString())"
        }
        let header = ["Authorization": basicAuth]
        let params = ["client_id": clientId, "client_secret": clientSecret]
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        Server.callAPI(URL(string: APIServer.loginURL)!, method: .post, parameters: params, headers: header, encoding: JSONEncoding.default) { (json, error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if json?["token"].string != nil {
                UserDefaults.standard.set(basicAuth, forKey: "userToken")
                self.performSegue(withIdentifier: "tabBarSegue", sender: nil)
            }
            else {
                self.userNameField.shake()
                self.passwordField.shake()
            }
        }
        
    }

}

