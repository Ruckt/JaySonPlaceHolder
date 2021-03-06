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
        
        DispatchQueue.global(qos: .userInitiated).async { () in
            
            JPNetworkManager().fetchTypicodeAlbumService(random, completion: {[weak self] (albumDetails) in
                
                if let albumDetails = albumDetails {
                    self?.requestImageDataForPhotos(albumDetails, completion: { (dataArray) in
                        
                        DispatchQueue(label: "sortQueue").sync {
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
        
        let downloadGroup = DispatchGroup()
        let queue = DispatchQueue.global(qos: .default)
        
        for spec in albumSpecs {
            
            if let spot = spec.orderedSpot,
                let urlString = spec.thumbnailUrl,
                let httpUrl = URL(string: urlString) {
                
                downloadGroup.enter()
                
                queue.async {
                    JPNetworkManager().fetchImageDataService(httpUrl, completion: { (image) in
                        
                        if let image = image {
                            let thumbnailPlusData = JPTypicodeThumbnailPlusImageData(specs: spec, image: image, orderedSpot: spot)
                            
                            DispatchQueue.global(qos: .userInitiated).async(group:downloadGroup) {
                                
                                DispatchQueue(label: "syncQueue").sync {
                                    dataArray.append(thumbnailPlusData)
                                }
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
