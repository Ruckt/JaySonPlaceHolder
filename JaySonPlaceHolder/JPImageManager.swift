//
//  JPImageManager.swift
//  JaySonPlaceHolder
//
//  Created by Edan Lichtenstein on 8/19/17.
//  Copyright © 2017 Ruckt. All rights reserved.
//

import Foundation
import UIKit

class JPImageManager  {
    
 //   let cache = Cache()
    
    func requestImages(random: Int, completion: @escaping (ThumbnailsDataArray?) -> Void) {
        
        DispatchQueue.global(qos: .userInitiated).async { () in
            
            let manager = JPNetworkManager()
            manager.fetchTypicodeAlbumService(random, completion: { (albumDetails) in
                
                if let albumDetails = albumDetails {
                    //self?.cache. write to
                    self.requestImageDataForPhotos(albumDetails, completion: { (dataArray) in
                        completion(dataArray)
                    })
                } else {
                    completion(nil)
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
            
            if let spot = spec.orderedSpot,
                let urlString = spec.thumbnailUrl,
                let httpUrl = URL(string: urlString) {
                
                downloadGroup.enter()
                
                queue.async {
                    manager.fetchImageDataService(httpUrl, completion: { (image) in
                        
                        if let image = image {
                            let thumbnailPlusData = JPTypicodeThumbnailPlusImageData(specs: spec, image: image, orderedSpot: spot)
                            
                            print("PLUS image data: \(thumbnailPlusData.specs.title!)")
                            DispatchQueue.global(qos: .userInitiated).async(group:downloadGroup) {
                                print("Data Array: \(dataArray.count)")

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
