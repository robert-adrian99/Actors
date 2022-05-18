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
    
    init(frc: NSFetchedResultsController<NSFetchRequestResult>) {

        for section in frc.sections! {
            for object in section.objects! {
                let actorCD = object as! ActorCD
                actors.append(Actor(name: actorCD.name!, cityOfBirth: actorCD.cityOfBirth!, description: actorCD.actorDescription!, images: actorCD.images!, phoneNo: actorCD.phoneNo!, email: actorCD.email!, website: actorCD.website!, filmography: actorCD.filmography!, age: Int(actorCD.age), isFavourite: actorCD.isFavourite, category: actorCD.category!))
            }
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
    
    func addFavouriteActors(to context: NSManagedObjectContext) {
        for actor in actors where actor.isFavourite {
            let entity = NSEntityDescription.entity(forEntityName: "FavouriteActorCD", in: context)
            let favActorCD = FavouriteActorCD(entity: entity!, insertInto: context)
            
            favActorCD.name             = actor.name
            favActorCD.category         = actor.category
            favActorCD.age              = Int16(actor.age)
            favActorCD.cityOfBirth      = actor.cityOfBirth
            favActorCD.phoneNo          = actor.phoneNo
            favActorCD.email            = actor.email
            favActorCD.actorDescription = actor.description
            favActorCD.website          = actor.website
            favActorCD.filmography      = actor.filmography
            favActorCD.images           = actor.images
            favActorCD.isFavourite      = actor.isFavourite
        }
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}
