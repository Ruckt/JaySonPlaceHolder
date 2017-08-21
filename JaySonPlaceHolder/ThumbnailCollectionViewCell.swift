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
    @IBOutlet var leftPadding: NSLayoutConstraint!
    @IBOutlet var rightPadding: NSLayoutConstraint!
    @IBOutlet var topPadding: NSLayoutConstraint!
    @IBOutlet var bottomPadding: NSLayoutConstraint!
    
    static let kCellIdentifier = "ThumbnailImageCellID"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
    func configureWithImage(_ image: UIImage?, _ padding: CGFloat) {
        
        leftPadding.constant = padding
        rightPadding.constant = padding
        bottomPadding.constant = padding
        topPadding.constant = padding
        
        if let image = image {
            self.imageView.image = image
        }
    }
}
