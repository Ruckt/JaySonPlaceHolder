//
//  AlbumViewController+DelegateMethods.swift
//  JaySonPlaceHolder
//
//  Created by Edan Lichtenstein on 8/20/17.
//  Copyright © 2017 Ruckt. All rights reserved.
//

import Foundation
import UIKit

extension AlbumViewController: UICollectionViewDelegateFlowLayout {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.thumbnailsArray.count * self.multiplier
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumbnailCollectionViewCell.kCellIdentifier,
                                                      for: indexPath) as? ThumbnailCollectionViewCell
        else {
                print("Unable to dequeue a thumbnail cell")
                return UICollectionViewCell.init()
        }

        let specs = self.thumbnailsArray[indexPath.row % (self.thumbnailsArray.count - 1)]
        
        if let image = specs.image {
            cell.configureWithImage(image, CGFloat(self.randomPadding))
        }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.randomCellSize
        return CGSize(width: size, height: size);
    }
    
}
