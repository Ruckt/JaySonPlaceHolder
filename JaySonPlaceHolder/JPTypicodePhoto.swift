//
//  JPTypicodePhoto.swift
//  JaySonPlaceHolder
//
//  Created by Edan Lichtenstein on 8/19/17.
//  Copyright © 2017 Ruckt. All rights reserved.
//

import Foundation
import UIKit

struct JPTypicodePhotoSpecs {
    var albumId: Int?
    var id: Int?
    var title: String?
    var url: String?
    var thumbnailUrl: String?
    var orderedSpot: Int?
}

typealias TypicodePhotoSpecsArray = [JPTypicodePhotoSpecs]

struct JPTypicodeThumbnailPlusImageData {
    var specs: JPTypicodePhotoSpecs
    var image: UIImage?
    var orderedSpot: Int
}

typealias ThumbnailsDataArray = [JPTypicodeThumbnailPlusImageData]
