//
//  JPNetworkManager.swift
//  JaySonPlaceHolder
//
//  Created by Edan Lichtenstein on 8/19/17.
//  Copyright © 2017 Ruckt. All rights reserved.
//

import Foundation
import UIKit

let kTypicodeRootURL = "https://jsonplaceholder.typicode.com"
let kAlbumsExtension = "/albums"
let kPhotosEndpoint = "/photos"

class JPNetworkManager {
    
    func fetchTypicodeAlbumService(_ unit: Int, completion: @escaping (TypicodePhotoSpecsArray?) -> Void) {
        
        guard let url = URL(string: kTypicodeRootURL + kAlbumsExtension + "/\(unit)" + kPhotosEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        print(urlRequest)
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            if let error = error {
                print("Error while fetching image data: \(error)")
                completion(nil)
                return
            }
            
            
            guard let data = data,
                let json = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
                    print("Nil data received from Typicode service")
                    completion(nil)
                    return
            }
            
            var count = 0
            
            if let json = json {
                let photosSpecs = json.flatMap({ (dict) -> JPTypicodePhotoSpecs? in
                    guard let albumId = dict["albumId"] as? Int,
                        let id = dict["id"] as? Int,
                        let title = dict["title"] as? String,
                        let url = dict["url"] as? String,
                        let thumbnailUrl = dict["thumbnailUrl"] as? String
                        else { return nil }
                    
                    
                    
                    let specs =  JPTypicodePhotoSpecs(albumId: albumId,
                                                      id: id,
                                                      title: title,
                                                      url:url.replacingOccurrences(of: "http://", with: "https://"),
                                                      thumbnailUrl: thumbnailUrl.replacingOccurrences(of: "http://", with: "https://"),
                                                      orderedSpot: count)
                    count += 1
                    
                    return specs
                })
                completion(photosSpecs)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func fetchImageDataService(_ url: URL, completion: @escaping (UIImage?) -> Void) {
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Error downloading image: \(error)")
                completion(nil)
            } else {
                guard (response as? HTTPURLResponse) != nil
                    else {
                        print("No response on image download")
                        completion(nil)
                        return
                }
                
                if let data = data,
                    let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }
        task.resume()
    }

}
