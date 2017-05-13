//
//  EditProfileTableViewController.swift
//  Eaze
//
//  Created by Jerry Shi on 3/13/17.
//  Copyright © 2017 easeapp. All rights reserved.
//

import Foundation
import UIKit

class EditProfileTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var imagePicker = UIImagePickerController()

    
    @IBOutlet var editableProfileImageView: UIImageView!
    @IBAction func changeProfilePictureButton(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
        
        self.editableProfileImageView.image = image
    }
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var emailLabel: UILabel!
    
    @IBOutlet var phonenumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserInfo()
        
    }
    func setupUserInfo() {
        if let user = CoreDataMethods.shared.fetchUser(GlobalVariables.userEmail) {
            GlobalVariables.currentUser = user
            self.emailLabel.text = user.email
            self.nameLabel.text = "\(user.firstName!) \(user.lastName!)"
        }
        //UserDefaults.standard.set(false, forKey: GlobalKeys.kNeverShowMigrationAlert)
        
    }

    override func viewDidAppear(_ animated: Bool) {
    }
    
    //1. Create the alert controller.
        //let secondAlert = UIAlertController(title: "Invalid Phone Number", message: "Please enter a valid phone number to continue", preferredStyle: .alert)
    var userPhoneNumber: Int = 0
    
    func alertViewToUpdate() {
        let alert = UIAlertController(title: "Add Phone Number", message: "Shops could only use your phone number for appointment updates and verification.", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Enter here"
            textField.keyboardType = UIKeyboardType.numberPad
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
            if let textField = alert?.textFields![0] {
                // Force unwrapping because we know it exists.
                //userPhoneNumber = Double(textField.text)
                let number = Int(textField.text!)
                self.userPhoneNumber = Int(number!)
                print("Text field: \(self.userPhoneNumber)")
                
//                let digitCount = self.selfDivide(number: self.userPhoneNumber)
//                if digitCount < 10 {
//                    //show alert: please enter a valid phone number
//                    
//                    self.secondAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction) in
//                        //lol
//                        print("invalid number")
//                    }))
//                }else{
//                    self.phonenumberLabel.text = String("\(self.userPhoneNumber)")
//                }
//                
                self.phonenumberLabel.text = String("\(self.userPhoneNumber)")

            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) -> Void in}))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    func selfDivide(number: Int) -> Int {
        var num = abs(number)
        var count = 0
        while num > 0 {
            let digit = num % 10
            if digit != 0 && number % digit == 0 {
                count += 1
            }
            num = num / 10
        }
        return count
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.section {
        case 1:
            if indexPath.row == 2 {
                alertViewToUpdate()
            }
            
        default:
            break;
        }
    }
}
