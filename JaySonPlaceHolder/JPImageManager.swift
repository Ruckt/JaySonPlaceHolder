//
//  JPImageManager.swift
//  JaySonPlaceHolder
//
//  Created by Edan Lichtenstein on 8/19/17.
//  Copyright © 2017 Ruckt. All rights reserved.
//

import Foundation

class JPImageManager  {
    
 //   let cache = Cache()
    
    func requestImages(completion: @escaping (Array<Any>?) -> Void) {
        
    //    get images out of cache first
        
        let manager = JPNetworkManager()
        
        
        DispatchQueue.global(qos: .userInitiated).async { () in // [weak self] in
            
            manager.fetchTypicodeAlbumService(1, completion: { (albumDetails) in
                
                print(albumDetails!)
                
                if let albumDetails = albumDetails {
                    //self?.cache. write to
                    self.requestImageDataForPhotos(albumDetails, completion: { (dataArray) in
                        completion(dataArray)
                    })
                } else {
                    completion(nil)
                    //completion(nil, true)
                }
            })
        }
    }

    private func requestImageDataForPhotos(_ albumSpecs: TypicodePhotoSpecsArray, completion: @escaping(_ thumbnail: ThumbnailsDataArray) -> Void) {
        
        var dataArray = ThumbnailsDataArray()
        
        let downloadGroup = DispatchGroup()
        let queue = DispatchQueue.global(qos: .default)
        let manager = JPNetworkManager()
        
        for spec in albumSpecs {
           // let urlTuple = self.cache.getImageURLandFileURLFor(photoURL)
            
            if let spot = spec.orderedSpot,
                let urlString = spec.thumbnailUrl,
                let httpUrl = URL(string: urlString) {
                
                downloadGroup.enter()
                
                queue.async {
                    manager.fetchImageDataService(httpUrl, completion: { (imageData) in
                        
                        if let data = imageData {
                            
                            let thumbnailPlusData = JPTypicodeThumbnailPlusImageData(specs: spec, data: data, orderedSpot: spot)
                            
                            DispatchQueue.global(qos: .userInitiated).async(group:downloadGroup) {
                                dataArray.append(thumbnailPlusData)
                            }
                        }
                        downloadGroup.leave()
                    })
                }
            }
        }
        
        downloadGroup.notify(queue: queue) {
            dataArray.sort{ $0.orderedSpot < $1.orderedSpot }
            completion(dataArray)
        }
    }

}
