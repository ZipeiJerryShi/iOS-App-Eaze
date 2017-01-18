//
//  ViewController.swift
//  Eaze
//
//  Created by Jerry Shi on 1/17/17.
//  Copyright © 2017 easeapp. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubview(loginButton)
        loginButton.center = view.center
        loginButton.delegate = self
        if let token = FBSDKAccessToken.current() {
            fetchProfile()
        }
    }
    
    func fetchProfile(){
        print("Fetch Profile")
        
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "email, first_name, last_name, id, gender, picture"])
            .start(completionHandler:  {
                (connection, result, error) in
                guard
                    let result = result as? NSDictionary,
                    let email = result["email"] as? String,
                    let first_name = result["first_name"] as? String,
                    let last_name = result["last_name"] as? String,
                    let user_gender = result["gender"] as? String,
                    let user_id_fb = result["id"]  as? String
                    //let picture = result["picture.type(large)"] as? NSDictionary, let data = picture["data"] as? NSDictionary, let url = data["url"] as? String
                    else {
                        return
                }
                
                print(email) //getting the email of the user
                print(first_name) //user name
                print(last_name)
                print(user_gender) //user gender
                print(user_id_fb) //facebook id
                if let picture = result["picture"] as? [String:Any] ,
                    let imgData = picture["data"] as? [String:Any] ,
                    let imgUrl = imgData["url"] as? String {
                    print(imgUrl)   //profile image url
                }
            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //delegate methods
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("Completed login")
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    }
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
}

