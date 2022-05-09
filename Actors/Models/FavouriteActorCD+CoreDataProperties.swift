//
//  FavouriteActorCD+CoreDataProperties.swift
//  Actors
//
//  Created by Robert Adrian Bucur on 09/05/2022.
//
//

import Foundation
import CoreData


extension FavouriteActorCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteActorCD> {
        return NSFetchRequest<FavouriteActorCD>(entityName: "FavouriteActorCD")
    }

    @NSManaged public var actorDescription: String?
    @NSManaged public var age: Int16
    @NSManaged public var isFavourite: Bool
    @NSManaged public var category: String?
    @NSManaged public var cityOfBirth: String?
    @NSManaged public var email: String?
    @NSManaged public var filmography: Array<String>?
    @NSManaged public var images: Array<Data>?
    @NSManaged public var name: String?
    @NSManaged public var phoneNo: String?
    @NSManaged public var website: String?

}

extension FavouriteActorCD : Identifiable {

}
