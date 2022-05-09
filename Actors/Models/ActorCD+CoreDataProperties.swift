//
//  ActorCD+CoreDataProperties.swift
//  Actors
//
//  Created by Robert Adrian Bucur on 09/05/2022.
//
//

import Foundation
import CoreData


extension ActorCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActorCD> {
        return NSFetchRequest<ActorCD>(entityName: "ActorCD")
    }

    @NSManaged public var name: String?
    @NSManaged public var age: Int16
    @NSManaged public var category: String?
    @NSManaged public var cityOfBirth: String?
    @NSManaged public var actorDescription: String?
    @NSManaged public var phoneNo: String?
    @NSManaged public var email: String?
    @NSManaged public var website: String?
    @NSManaged public var images: Array<Data>?
    @NSManaged public var filmography: Array<String>?
    @NSManaged public var isFavourite: Bool

}

extension ActorCD : Identifiable {

}
