//
//  Actors.swift
//  Actors
//
//  Created by Robert Adrian Bucur on 06/05/2022.
//

import Foundation

class Actors {
    var data: [Actor]
    
    init() {
        data = []
    }
    
    init(xmlFilename: String) {
        // make a parsing object
        let xmlActorParser = XMLActorParser(filename: xmlFilename)
        xmlActorParser.parsing()
        
        // self data
        self.data = xmlActorParser.actorsData
    }
}
