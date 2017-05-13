//
//  profileViewController.swift
//  Eaze
//
//  Created by Jerry Shi on 2/15/17.
//  Copyright © 2017 easeapp. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class profileViewController: UITableViewController  {
    
    var users: [NSManagedObject] = []
    
    
    @IBOutlet var backgroundImg: UIImageView!
    
    @IBOutlet var userProfilePic: UIImageView!
    
    @IBOutlet var userName: UILabel!
    
    @IBOutlet var userEmail: UILabel!
    
    
    
    @IBAction func logoutButton(_ sender: Any) {
        logoutButtonAction()
    }
    
    
    func logoutButtonAction() {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        self.performSegue(withIdentifier: "logoutAppSegue", sender: self)
    }
    
    
    
    func imageWithGradient(img: UIImage) -> UIImage {
        
        UIGraphicsBeginImageContext(img.size)
        let context = UIGraphicsGetCurrentContext()
        
        img.draw(at: CGPoint(x: 0, y: 0))
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations:[CGFloat] = [0.0, 1.0]
        
        let bottom = UIColor(red: 255, green: 255, blue: 255, alpha: 1).cgColor
        let top = UIColor(red: 255, green: 255, blue: 255, alpha: 0.5).cgColor
        
        let colors = [top, bottom] as CFArray
        
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations)
        
        let startPoint = CGPoint(x: img.size.width/2, y: img.size.height/1.2)
        let endPoint = CGPoint(x: img.size.width/2, y: img.size.height)
        
        context!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
    
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
                
                let localProfilePicImage = self.userProfilePic.image
                let imageData:NSData = UIImagePNGRepresentation(self.userProfilePic.image!)! as NSData
                
                //saved image
                UserDefaults.standard.set(imageData, forKey: "localProfilePicImage")
                
                //decode
                let localProfileImageData = UserDefaults.standard.object(forKey: "localProfilePicImage") as! NSData
                
                self.userProfilePic.image = UIImage(data: localProfileImageData as Data)
                
                
                self.backgroundImg.image = self.imageWithGradient(img: self.userProfilePic.image!)
            }
        }
    }
    
    func save(firstName: String, lastName: String, email: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
        let user = NSManagedObject(entity: entity, insertInto: managedContext)
        
        user.setValue(firstName, forKeyPath: "firstName")
        user.setValue(lastName, forKeyPath: "lastName")
        user.setValue(email, forKeyPath: "email")
        
        do {
            try managedContext.save()
            users.append(user)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let user = CoreDataMethods.shared.fetchUser(UserDefaults.standard.integer(forKey: ServerCallsVariables.kMyUserId)) {
//            GlobalVariables.currentUser = user
//            self.userEmail.text = user.email
//            self.userName.text = "\(user.firstName) \(user.lastName)"
//        }
        
        setupUserInfo()
        setCircleImage()
        downloadImage()
    
    }
    
    func setupUserInfo() {
        if let user = CoreDataMethods.shared.fetchUser(GlobalVariables.userEmail) {
            GlobalVariables.currentUser = user
            self.userEmail.text = user.email
            self.userName.text = "\(user.firstName!) \(user.lastName!)"
        }
        //UserDefaults.standard.set(false, forKey: GlobalKeys.kNeverShowMigrationAlert)

    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    
    //tableView methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        
        switch (indexPath as NSIndexPath).section {
        case 0:
            break;
        case 1:
            if indexPath.row == 0 {
                self.performSegue(withIdentifier: "showMyProfile", sender: self)
                tableView.deselectRow(at: indexPath, animated: false)
            }else if indexPath.row == 1{
                self.performSegue(withIdentifier: "showPayment", sender: self)
                tableView.deselectRow(at: indexPath, animated: false)
            }

        default:
            break;
            
        }
    }

}
