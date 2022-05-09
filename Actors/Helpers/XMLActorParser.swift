//
//  XMLActorParser.swift
//  Actors
//
//  Created by Robert Adrian Bucur on 06/05/2022.
//

import Foundation
import UIKit

class XMLActorParser: NSObject, XMLParserDelegate {
    
    var name: String!
    
    // vars and objects needed for parsing
    var aName, aCityOfBirth, aDescription, aPhoneNo, aEmail, aWebsite,  aCategory: String!
    var aImages      = [Data]()
    var aFilmography = [String]()
    var aAge: Int!
    var aIsFavourite: Bool!
    
    var actorsData = [Actor]()
    
    var elemId = -1
    var passData = false
    
    var parser: XMLParser!
    
    let tags = ["name", "cityOfBirth", "description", "image", "phoneNo", "email", "website", "film", "age", "category", "isFavourite"]
    
    init(filename: String) {
        self.name = filename
    }
    
    // delegate methods
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if tags.contains(elementName) {
            passData = false
            elemId = -1
        }
        
        if elementName == "actor" {
            
            actorsData.append(Actor(name: aName, cityOfBirth: aCityOfBirth, description: aDescription, images: aImages, phoneNo: aPhoneNo, email: aEmail, website: aWebsite, filmography: aFilmography, age: aAge, isFavourite: aIsFavourite, category: aCategory))
            aFilmography = []
            aImages      = []
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        // check if elementName is in tags
        if tags.contains(elementName) {
            passData = true
            elemId = tags.firstIndex(of: elementName)!
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if passData {
            switch elemId {
            case 0:
                aName = string
            case 1:
                aCityOfBirth = string
            case 2:
                aDescription = string
            case 3:
                let imageData = UIImage(named: string)?.pngData()
                aImages.append(imageData!)
            case 4:
                aPhoneNo = string
            case 5:
                aEmail = string
            case 6:
                aWebsite = string
            case 7:
                aFilmography.append(string)
            case 8:
                aAge = Int(string)
            case 9:
                aCategory = string
            case 10:
                aIsFavourite = Bool(string)
            default:
                break
            }
        }
    }
    
    func parsing() {
        
        // get the xml path
        let bundleUrl = Bundle.main.bundleURL
        let fileUrl   = URL(fileURLWithPath: self.name, relativeTo: bundleUrl)
        
        // make the xmlparser
        parser = XMLParser(contentsOf: fileUrl)
        
        // set the delegate and parse
        parser.delegate = self
        parser.parse()
    }
}
