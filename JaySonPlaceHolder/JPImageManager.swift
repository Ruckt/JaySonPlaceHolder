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
    
    func requestImages(random: Int, completion: @escaping (ThumbnailsDataArray?) -> Void) {
        
        let queue = DispatchQueue(label: "requestImages", qos: .userInitiated)
        
        queue.async {
            
            JPNetworkManager().fetchTypicodeAlbumService(random, completion: {[weak self] (albumDetails) in
                
                if let albumDetails = albumDetails {
                    self?.requestImageDataForPhotos(albumDetails, completion: { (dataArray) in
                        let sortQueue  = DispatchQueue(label: "sortQueue")
                        sortQueue.sync {
                            completion(dataArray.sorted{ $0.orderedSpot < $1.orderedSpot })
                        }
                    })
                } else {
                    completion(nil)
                }
            })
        }
    }

    private func requestImageDataForPhotos(_ albumSpecs: TypicodePhotoSpecsArray, completion: @escaping(_ thumbnail: ThumbnailsDataArray) -> Void) {
        
        var dataArray = ThumbnailsDataArray()
        dataArray.reserveCapacity(50)
        
        let downloadGroup = DispatchGroup()
        let queue = DispatchQueue(label: "requestImageData")
        
        for spec in albumSpecs {
            
            if let spot = spec.orderedSpot,
                let urlString = spec.thumbnailUrl,
                let httpUrl = URL(string: urlString) {
                
                queue.async(group:downloadGroup) {
                    downloadGroup.enter()
                    JPNetworkManager().fetchImageDataService(httpUrl, completion: { (image) in
                        
                        let fetchQueue = DispatchQueue(label: "fetchQueue")
                        fetchQueue.sync {
                            
                            if let image = image {
                                dataArray.append(JPTypicodeThumbnailPlusImageData(specs: spec, image: image, orderedSpot: spot))
                            }
                        }
                        downloadGroup.leave()
                    })
                }
            }
        }
        
        downloadGroup.notify(queue: queue) {
            completion(dataArray)
        }
    }

}
