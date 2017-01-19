//
//  userViewController.swift
//  Eaze
//
//  Created by Jerry Shi on 1/18/17.
//  Copyright © 2017 easeapp. All rights reserved.
//

import UIKit

class userViewController: UIViewController {
    
    @IBOutlet var userName: UILabel!
    
    @IBOutlet var userEmail: UILabel!
    
    @IBOutlet var userId: UILabel!
    
    @IBOutlet var userImageUrl: UILabel!

    @IBAction func logoutButton(_ sender: Any) {
        logoutButtonAction()
    }

    @IBOutlet var userProfilePic: UIImageView!
    
    func setCircleImage() {
        //self.userProfilePic.layer.borderWidth = 1
        self.userProfilePic.layer.masksToBounds = false
        //self.userProfilePic.layer.borderColor = UIColor.white.cgColor
        self.userProfilePic.layer.cornerRadius = self.userProfilePic.frame.height/2
        self.userProfilePic.clipsToBounds = true
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage() {
        let url = NSURL(string: GlobalVariables.userPicUrl)
        getDataFromUrl(url: url as! URL) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { () -> Void in
                self.userProfilePic.image = UIImage(data: data)
            }
        }
    }
    
    func logoutButtonAction() {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        self.performSegue(withIdentifier: "logoutAppSegue", sender: self)
    }
    
    func setUserInfo(){
        self.userName.text = GlobalVariables.userFirstName + " " + GlobalVariables.userLastName
        self.userEmail.text = GlobalVariables.userEmail
        self.userId.text = GlobalVariables.userId
        self.userImageUrl.text = GlobalVariables.userPicUrl
    }
    
    
    override func viewDidLoad() {
        setUserInfo()
        setCircleImage()
        downloadImage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
