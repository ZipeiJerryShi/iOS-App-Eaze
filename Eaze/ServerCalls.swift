//
//  ServerCalls.swift
//  Eaze
//
//  Created by Jerry Shi on 3/13/17.
//  Copyright © 2017 easeapp. All rights reserved.
//

import Foundation
import CoreData
import Alamofire

var alamoFireManager = Alamofire.SessionManager()
let configuration = URLSessionConfiguration.default
let timeOutString = "Poor server connection. The request timed out."
let cancelledString = "Something went wrong!"
var postLegacyCount: Int = 0
let seconds: Double = 15
let authorizationError = "status401"

func setAlamoFireTimeout() {
    configuration.timeoutIntervalForRequest = seconds
    configuration.timeoutIntervalForResource = seconds
    configuration.httpMaximumConnectionsPerHost = 10 // Some arbitrary number that I feel big enough.
    alamoFireManager = Alamofire.SessionManager(configuration: configuration)
}

func checkAndStoreOrUpdateUser(_ id: String, firstName: String, lastName: String, phoneNumber: Int32, email: String) {
    if email.characters.count > 0 {
        if CoreDataMethods.shared.checkIfUserExists(email) {
            //update user
            CoreDataMethods.shared.updateUser(id as AnyObject, objectName: "id", email: email.lowercased())
            if firstName.characters.count > 0 {
                CoreDataMethods.shared.updateUser(firstName as AnyObject, objectName: "firstName", email: email.lowercased())
            }
            if lastName.characters.count > 0 {
                CoreDataMethods.shared.updateUser(lastName as AnyObject, objectName: "lastName", email: email.lowercased())
            }
            if phoneNumber > 0 {
                CoreDataMethods.shared.updateUser(phoneNumber as AnyObject, objectName: "phoneNumber", email: email.lowercased())
            }
        } else {
            //create user
            CoreDataMethods.shared.storeUser(id: id, email: email, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
        }
    }
}
