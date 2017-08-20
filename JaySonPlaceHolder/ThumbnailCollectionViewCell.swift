//
//  ThumbnailCollectionViewCell.swift
//  JaySonPlaceHolder
//
//  Created by Edan Lichtenstein on 8/20/17.
//  Copyright © 2017 Ruckt. All rights reserved.
//

import Foundation
import UIKit

class ThumbnailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    static let kCellIdentifier = "ThumbnailImageCellID"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
    func configureWithImage(_ image: UIImage?) {
        if let image = image {
            self.imageView.image = image
        }
    }
}
