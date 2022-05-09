//
//  ActorRepository.swift
//  Actors
//
//  Created by Robert Adrian Bucur on 09/05/2022.
//

import UIKit
import CoreData

class ActorRepository {
    
    var actors     = [Actor]()
    
    init(xmlFilename: String) {
        
        let actorsXml = Actors(xmlFilename: xmlFilename)
    
        for actorXml in actorsXml.data {
            
            let actor = Actor(name: actorXml.name, cityOfBirth: actorXml.cityOfBirth, description: actorXml.description, images: actorXml.images, phoneNo: actorXml.phoneNo, email: actorXml.email, website: actorXml.website, filmography: actorXml.filmography, age: actorXml.age, isFavourite: actorXml.isFavourite, category: actorXml.category)
            
            actors.append(actor)
        }
    }
    
    func addActors(to context: NSManagedObjectContext) {
        for actor in actors {
            let entity = NSEntityDescription.entity(forEntityName: "ActorCD", in: context)
            let actorCD = ActorCD(entity: entity!, insertInto: context)
            
            actorCD.name             = actor.name
            actorCD.category         = actor.category
            actorCD.age              = Int16(actor.age)
            actorCD.cityOfBirth      = actor.cityOfBirth
            actorCD.phoneNo          = actor.phoneNo
            actorCD.email            = actor.email
            actorCD.actorDescription = actor.description
            actorCD.website          = actor.website
            actorCD.filmography      = actor.filmography
            actorCD.images           = actor.images
            actorCD.isFavourite      = actor.isFavourite
        }
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}
