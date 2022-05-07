//
//  Actor.swift
//  Actors
//
//  Created by Robert Adrian Bucur on 06/05/2022.
//

import Foundation

let notDefinedString: String = "N\\A"

class Actor {
    var name, cityOfBirth, description, phoneNo, email, website: String
    var images, filmography: [String]
    var age: Int
    var isFavourite: Bool
    
    init() {
        name        = notDefinedString
        cityOfBirth = notDefinedString
        description = notDefinedString
        filmography = [notDefinedString]
        age         = 0
        images      = [notDefinedString]
        phoneNo     = notDefinedString
        email       = notDefinedString
        website     = notDefinedString
        isFavourite = false
    }
    
    init(name       : String,
         cityOfBirth: String,
         description: String,
         images     : [String],
         phoneNo    : String,
         email      : String,
         website    : String,
         filmography: [String],
         age        : Int,
         isFavourite: Bool) {
        
        self.name        = name
        self.cityOfBirth = cityOfBirth
        self.description = description
        self.filmography = filmography
        self.age         = age
        self.images      = images
        self.phoneNo     = phoneNo
        self.email       = email
        self.website     = website
        self.isFavourite = isFavourite
    }
}
