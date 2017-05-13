//
//  User+CoreDataProperties.swift
//  Eaze
//
//  Created by Jerry Shi on 3/25/17.
//  Copyright © 2017 easeapp. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User");
    }

    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var id: String?
    @NSManaged public var lastName: String?
    @NSManaged public var localProfilePicImage: NSData?
    @NSManaged public var phoneNumber: Int32

}
