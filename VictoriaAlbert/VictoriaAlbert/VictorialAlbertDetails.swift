//
//  VictorialAlbertDetails.swift
//  VictoriaAlbert
//
//  Created by Tyler Newton on 12/4/16.
//  Copyright © 2016 Tyler Newton. All rights reserved.
//

import Foundation

class VictoriaAlbertDetails {
    let object: String
    let dateText: String
    let place: String
    let artist: String
    let imageID: String
    let thumbnail: String
    let largestImage: String
    
    init(object: String, dateText: String, place: String, artist: String, imageID: String, thumbnail: String, largestImage: String){
        
    self.object = object
    self.dateText = dateText
    self.place = place
    self.artist = artist
    self.imageID = imageID
    self.thumbnail = thumbnail
    self.largestImage = largestImage

    }
}
