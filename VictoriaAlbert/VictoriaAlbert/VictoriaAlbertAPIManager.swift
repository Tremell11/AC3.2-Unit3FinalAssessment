//
//  VictoriaAlbertAPIManager.swift
//  VictoriaAlbert
//
//  Created by Tyler Newton on 12/4/16.
//  Copyright © 2016 Tyler Newton. All rights reserved.
//

import Foundation

class VictoriaAlbertAPIManager {
    static let manager = VictoriaAlbertAPIManager()
    private init () {}
    
    class func getDetails(from endpoint: String, callback: @escaping ([VictoriaAlbertDetails]?) -> Void) {
        
        guard let validEndpoint = URL(string: endpoint) else { return }
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: validEndpoint) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil {
                print(error.debugDescription)
            }
            guard let validData: Data = data else { return }
            
            let details = VictoriaAlbertAPIManager.manager.getDetails(from: validData)
            
            callback(details)
            
            }.resume()
    }
    func getDetails(from data: Data) -> [VictoriaAlbertDetails]? {
        do {
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            var allDetails = [VictoriaAlbertDetails]()
            
            guard let json = jsonData as? [String:Any],
                let record = json["records"] as? [[String:Any]] else { return nil }
            for detail in record {
                guard let objectData = detail["fields"] as? [String:Any],
                    let object = objectData["object"] as? String,
                    let dateText = objectData["date_text"] as? String,
                    let place = objectData["place"] as? String,
                    let artist = objectData["artist"] as? String,
                    let imageID = objectData["primary_image_id"] as? String else { continue }
                
                
                var thumbnailImage = ""
                var largestImage = ""
                var count = 0
                let imageEndpoint = "http://media.vam.ac.uk/media/thira/collection_images/"
                var shorthandID = ""
                for character in imageID.characters {
                    count += 1
                    if count <= 6 {
                        shorthandID += String(character)
                    }
                }
                thumbnailImage += "\(imageEndpoint)\(shorthandID)/\(imageID)_jpg_o.jpg"
                
                largestImage += "\(imageEndpoint)\(shorthandID)/\(imageID).jpg"
                
                allDetails.append(VictoriaAlbertDetails(object: object, dateText: dateText, place: place, artist: artist, imageID: imageID, thumbnail: thumbnailImage, largestImage: largestImage))
            }
            
            return allDetails
        }
        catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
