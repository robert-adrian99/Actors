//
//  Actor.swift
//  Actors
//
//  Created by Robert Adrian Bucur on 06/05/2022.
//

import Foundation

class Actor {
    var name, cityOfBirth, description, phoneNo, email, website, category: String
    var images     : [Data]
    var filmography: [String]
    var age: Int
    var isFavourite: Bool
    
    init() {
        name        = "Name"
        cityOfBirth = "City of birth"
        description = "Description"
        filmography = ["Movie"]
        age         = 0
        images      = []
        phoneNo     = "Phone number"
        email       = "Email"
        website     = "Website"
        category    = "Category"
        isFavourite = false
    }
    
    init(name       : String,
         cityOfBirth: String,
         description: String,
         images     : [Data],
         phoneNo    : String,
         email      : String,
         website    : String,
         filmography: [String],
         age        : Int,
         isFavourite: Bool,
         category   : String) {
        
        self.name        = name
        self.cityOfBirth = cityOfBirth
        self.description = description
        self.filmography = filmography
        self.age         = age
        self.images      = images
        self.phoneNo     = phoneNo
        self.email       = email
        self.website     = website
        self.category    = category
        self.isFavourite = isFavourite
    }
    
    init(actorCD: ActorCD) {
        self.name        = actorCD.name!
        self.cityOfBirth = actorCD.cityOfBirth!
        self.description = actorCD.actorDescription!
        self.filmography = actorCD.filmography!
        self.age         = Int(actorCD.age)
        self.images      = actorCD.images!
        self.phoneNo     = actorCD.phoneNo!
        self.email       = actorCD.email!
        self.website     = actorCD.website!
        self.category    = actorCD.category!
        self.isFavourite = actorCD.isFavourite
    }
    
    init(favActorCD: FavouriteActorCD) {
        self.name        = favActorCD.name!
        self.cityOfBirth = favActorCD.cityOfBirth!
        self.description = favActorCD.actorDescription!
        self.filmography = favActorCD.filmography!
        self.age         = Int(favActorCD.age)
        self.images      = favActorCD.images!
        self.phoneNo     = favActorCD.phoneNo!
        self.email       = favActorCD.email!
        self.website     = favActorCD.website!
        self.category    = favActorCD.category!
        self.isFavourite = favActorCD.isFavourite
    }
}
