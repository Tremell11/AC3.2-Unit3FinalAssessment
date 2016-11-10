//
//  Object.swift
//  VictoriaAlbert
//
//  Created by Jason Gresh on 11/10/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

//fields: {
//    primary_image_id: "2013GJ6545",
//    rights: 3,
//    year_start: 1870,
//    object_number: "O370889",
//    artist: "",
//    museum_number: "886-1884",
//    object: "Pair of doors",
//    longitude: "31.74997500",
//    last_processed: "2016-10-29 09:01:50",
//    event_text: "",
//    place: "Cairo",
//    location: "In Storage",
//    last_checked: "2016-10-29 09:01:50",
//    museum_number_token: "8861884",
//    latitude: "30.14004500",
//    title: "",
//    date_text: "1870-1883 (made) 1300-1350 (made)",
//    slug: "pair-of-doors",
//    sys_updated: "2016-10-26 00:00:00",
//    collection_code: "FWK"
//}

import Foundation

class Object {
    let image_id: String
    let object: String
    let place: String
    let dateText: String
    let title: String
    
    init?(from dict: [String:Any]) {
        guard let image_id = dict["primary_image_id"] as? String,
        let object = dict["object"] as? String,
            let place = dict["place"] as? String,
            let dateText = dict["date_text"] as? String,
            let title = dict["title"] as? String else {
                return nil
        }
        self.image_id = image_id
        self.object = object
        self.place = place
        self.dateText = dateText
        self.title = title
    }
    
    static func parseObjects(from arr:[[String:Any]]) -> [Object] {
        var objects = [Object]()
        for objectDict in arr {
            if let fields = objectDict["fields"] as? [String:Any],
             let object = Object(from: fields) {
                objects.append(object)
            }
        }
        return objects
    }
    
    func imageURL(thumb: Bool = false) -> String {
        var urlString: String = "http://media.vam.ac.uk/media/thira/collection_images/"
        let prefix = self.image_id.substring(to: self.image_id.index(self.image_id.startIndex, offsetBy: 6))
        urlString += "\(prefix)/\(self.image_id)"
        
        if thumb {
            urlString += "_jpg_o"
        }
        urlString += ".jpg"
        
        return urlString
    }
}
