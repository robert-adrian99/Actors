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
}
