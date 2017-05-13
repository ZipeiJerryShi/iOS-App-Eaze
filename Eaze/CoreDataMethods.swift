//
//  CoreDataMethods.swift
//  Eaze
//
//  Created by Jerry Shi on 3/13/17.
//  Copyright © 2017 easeapp. All rights reserved.
//

import Foundation
import CoreData
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}
class CoreDataMethods {
    
    static let shared = CoreDataMethods()
    //MARK: Entities
    let kUserEntity = "User"
//    let kCarEntity = "Car"
//    let kAppointmentEntity = "Appointment"
//    let kIssueEntity = "Issue"
//    let kScannerEntity = "Scanner"
//    let kNotificationEntity = "Notifications"
//    let kShopEntity = "Shop"
//    let kPidDataEntity = "PidData"
//    let kPidEntity = "Pid"
    let managedObjectContext = DataController.sharedInstance.managedObjectContext
    let managedObjectParentContext = DataController.sharedInstance.managedObjectParentContext
    let writerManagedObjectContext = DataController.sharedInstance.writerManagedObjectContext

    let kCoreDataMethods: String = "Core Data Methods"
    
    func saveCoreDataObjects() {
        DispatchQueue.main.async(execute: {
            if self.managedObjectContext.hasChanges {
                self.managedObjectContext.perform({
                    do {
                        try self.managedObjectContext.save()
                        self.managedObjectParentContext.perform({
                            do {
                                try self.managedObjectParentContext.save()
                                self.writerManagedObjectContext.perform({
                                    do {
                                        try self.writerManagedObjectContext.save()
                                        //completion()
                                    } catch {
                                        print("failure to save writerManagedObjectContext: \(error)")
                                    }
                                })
                            } catch {
                                print("failure to save managedParentObjectContext: \(error)")
                            }
                        })
                    } catch {
                        print("failure to save managedObjectContext: \(error)")
                    }
                    
                })
            }
        })
    }
    
    //MARK: User Functions
    func storeUser(id: String, email: String, firstName: String, lastName: String, phoneNumber: Int32) {
        print("User does not exist. Creating user")
        let entity = NSEntityDescription.insertNewObject(forEntityName: kUserEntity, into: managedObjectContext) as! User
        entity.email = email as String
        entity.firstName = firstName as String
        entity.lastName = lastName as String
        entity.phoneNumber = Int32(phoneNumber)
        entity.id = id
        saveCoreDataObjects()
        
    }
    
    func checkIfUserExists(_ email: String) -> Bool {
        print("checkIfUserExists")
        var userExists: Bool = false
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: kUserEntity)
        let predicate = NSPredicate(format: "email == %@", email.lowercased())
        fetchRequest.predicate = predicate
        do {
            let fetchedUser = try managedObjectContext.fetch(fetchRequest) as! [User]
            //        log("checkIfUserExists - \(fetchedUser.count) users found when fetching users")
            //        for user in fetchedUser {
            //            log("checkIfUserExists - FetchUser: fetched user: \(user.firstName) \(user.lastName) id: \(user.id)")
            //        }
            if fetchedUser.count > 0 {
                userExists = true
            } else {
                userExists = false
            }
        } catch {
            print("failure to checkIfUserExists: \(error)")
        }
        return userExists
    }
    
    func fetchUser(_ email: String) -> User? {
        print("fetchUser")
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: kUserEntity)
        let predicate = NSPredicate(format: "email == %@", email)
        fetchRequest.predicate = predicate
        var user: User?
        do {
            let fetchedUsers = try managedObjectContext.fetch(fetchRequest) as! [User]
            print("\(fetchedUsers.count) users found")
            print("fetchUser.first: fetched user: \(fetchedUsers.first?.firstName) \(fetchedUsers.first?.lastName) id: \(fetchedUsers.first?.id)")
            user = fetchedUsers.first
        } catch {
            print("failure to fetchUser: \(error)")
        }
        return user
    }
    
    func updateUserPhoneAndName(_ id: Int, phoneNumber: Int32, firstName: String, lastName: String) {
        print("updateUserPhoneAndName: \(id); phone: \(phoneNumber); firstName: \(firstName); lastName: \(lastName)")
        //        GlobalVariables.currentUser
        GlobalVariables.currentUser?.phoneNumber = phoneNumber
        GlobalVariables.currentUser?.firstName = firstName
        GlobalVariables.currentUser?.lastName = lastName
        saveCoreDataObjects()
    }
    
    func updateUser(_ objectToUpdate: AnyObject, objectName: String, email: String) {
        print("updateUser")
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: kUserEntity)
        let predicate = NSPredicate(format: "email == %@", email.lowercased())
        fetchRequest.predicate = predicate
        
        do {
            let fetchedUsers = try managedObjectContext.fetch(fetchRequest) as! [User]
            if fetchedUsers.count > 0 {
                let firstUser = fetchedUsers.first
                switch objectName {
                case "id":
                    if let otu = objectToUpdate as? String {
                        if !otu.isEmpty {
                            firstUser?.id = otu
                        }
                    }
                case "firstName":
                    if let otu = objectToUpdate as? String {
                        if !otu.isEmpty {
                            firstUser?.firstName = otu
                        }
                    }
                case "lastName":
                    if let otu = objectToUpdate as? String {
                        if !otu.isEmpty {
                            firstUser?.lastName = otu
                        }
                    }
                case "email":
                    if let otu = objectToUpdate as? String {
                        if !otu.isEmpty {
                            firstUser?.email = otu
                        }
                    }
                case "phoneNumber":
                    if let otu = objectToUpdate as? Int32 {
                        if otu > 0 {
                            firstUser?.phoneNumber = otu
                        }
                    }
                default:
                    break;
                }
            }

            saveCoreDataObjects()
            
        } catch {
            print("failure to updateUser: \(error)")
        }
    }
    
}
