//
//  ViewController.swift
//  swift-facebook-login
//
//  Created by Guido Corazza on 11/8/17.
//  Copyright © 2017 Guido Corazza. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    var facebookLoginButton: FBSDKLoginButton = {
        var button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // FBSDK Native button
        self.facebookLoginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        self.facebookLoginButton.delegate = self
        self.view.addSubview(facebookLoginButton)
        
        // Custom button
        let customButton = UIButton(type: .system)
        customButton.setTitle("Log in with custom button", for: .normal)
        customButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        customButton.setTitleColor(.black, for: .normal)
        customButton.backgroundColor = .blue
        customButton.frame = CGRect(x: 16, y: 116, width: view.frame.width - 32, height: 50)
        customButton.addTarget(self, action: #selector(loginInWithCustomButton), for: .touchUpInside)
        self.view.addSubview(customButton)
        
        if FBSDKAccessToken.current() != nil {
            showUserDetails()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print("Error occurred while login ", error)
        }
        else if result.isCancelled {
            print("Login cancelled")
        }
        else {
            if result.grantedPermissions.contains("email") {
                print("Permission granted")
                showUserDetails()
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User logged out")
    }
    
    @objc func loginInWithCustomButton() {
        FBSDKLoginManager().logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if let error = error {
                print("Error occurred while login with custom button :", error)
            }
            else if (result?.isCancelled)! {
                print("Operation cancelled while login with custom button :")
            }
            else {
                if (result?.grantedPermissions.contains("email"))! {
                    self.showUserDetails()
                }
            }
        }
    }
    
    func showUserDetails() {
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "email, gender, id, name, first_name, last_name, picture.type(large)"]).start { (connection, result, error) in
            if let error = error {
                print("Error while fetching data ", error)
            }
            else {
                guard
                    let result = result as? NSDictionary,
                    let email = result["email"] as? String,
                    let name = result["name"] as? String,
                    let user_name = result["first_name"] as? String,
                    let last_name = result["last_name"] as? String,
                    let user_gender = result["gender"] as? String,
                    let user_id_fb = result["id"]  as? String
                    else {
                        return
                }
                
                print(result)
                print(email)
                print(name)
                print(user_name)
                print(last_name)
                print(user_gender)
                print(user_id_fb)
            }
        }
    }
}
