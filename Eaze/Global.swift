//
//  Global.swift
//  Eaze
//
//  Created by Jerry Shi on 1/18/17.
//  Copyright © 2017 easeapp. All rights reserved.
//

import Foundation

struct GlobalVariables {
    //user info
    static var userFirstName: String = ""
    static var userLastName: String = ""
    static var userEmail: String = ""
    static var userId: String = ""
    static var userGender: String = ""
    static var userPicUrl: String = ""
    
    static var currentUser: User?
    static var currentLoggedInUser: User?


    
}

struct ServerCallsVariables {
    //AWS Variables
    static let kMyUserId = "myUserId"
    static let kMyAccessToken = "accessToken"
    static let kRefreshToken = "refreshToken"
    static let kMyEmail = "myEmail"
    static let kMainCar = "mainCar"
    static let kUserSettingsType = "user"
    static let kShopSettingsType = "shop"
    static let kRecallMastersKey = "recall_recallmasters"
}


struct ViewControllerNames {
    //EditProfile
    static let kEditProfileTableViewController = "EditProfileTableViewController"
    static let kChangeProfilePictureViewController = "ChangeProfilePictureViewController"
    //signupLogin
    static let kNewDashboardTableViewController = "OnboardingPageViewController"
    static let kViewController = "ViewController"
    static let kOnboardingSubViewController = "OnboardingSubViewController"
    //location
    static let kcurrentLocViewController = "currentLocViewController"
    static let kNearbyTableViewController = "NearbyTableViewController"
    static let kNearbyTableViewCell = "NearbyTableViewCell"
    //user
    static let kprofileViewController = "profileViewController"
}

class DateMethods: NSObject {
    var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
    //    secondsFromGMT  // -7200
    
    func unixDateAsString() -> String {
        print("\(secondsFromGMT)")
        return "\(Int(Date().timeIntervalSince1970) + secondsFromGMT)"
    }
    
    func dateAsUnix() -> Int {
        print("\(Int(Date().timeIntervalSince1970) + secondsFromGMT) + \(secondsFromGMT) = \(Int(Date().timeIntervalSince1970) + secondsFromGMT + secondsFromGMT)")
        return Int(Date().timeIntervalSince1970) + secondsFromGMT + secondsFromGMT
    }
    
    func dateWithCorrectTimezone() -> Date {
        print("\(secondsFromGMT) ----- \(Date(timeIntervalSince1970: TimeInterval(dateAsUnix())))")
        return Date(timeIntervalSince1970: TimeInterval(dateAsUnix()))
    }
    
    func todaysDate() -> Date {
        var dayComponent = DateComponents()
        dayComponent.day = -1
        let calendar: Calendar! = Calendar(identifier: Calendar.Identifier.gregorian)
        let today = calendar.date(byAdding: dayComponent, to: dateWithCorrectTimezone(), wrappingComponents: true)
        return today!
    }
    
    func threeMonthsFromNow() -> Date {
        var monthComponent = DateComponents()
        monthComponent.month = 3
        let calendar: Calendar! = Calendar(identifier: Calendar.Identifier.gregorian)
        var threeMonthsFromNow: Date?
        threeMonthsFromNow = calendar.date(byAdding: monthComponent, to: dateWithCorrectTimezone(), wrappingComponents: true)
        let m = calendar.component(.month, from: dateWithCorrectTimezone())
        if (m + 3) > 12 {
            var yearComponent = DateComponents()
            yearComponent.year = 1
            threeMonthsFromNow = calendar.date(byAdding: yearComponent, to: threeMonthsFromNow!)
        }
        return threeMonthsFromNow!
    }
    
    enum UserParameterToUpdate {
        case id
        case email
        case firstName
        case lastName
        case phoneNumber
    }
}
