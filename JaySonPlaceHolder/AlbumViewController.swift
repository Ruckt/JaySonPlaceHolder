//
//  AlbumViewController.swift
//  JaySonPlaceHolder
//
//  Created by Edan Lichtenstein on 8/20/17.
//  Copyright © 2017 Ruckt. All rights reserved.
//

import Foundation
import UIKit

class AlbumViewController: UICollectionViewController {

    
    let imageManager = JPImageManager()
    
    var thumbnailsArray : ThumbnailsDataArray = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView?.reloadData()
            }
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.orange
 //       refreshControl.addTarget(self, action: #selector(self.refreshEmojis), for: .valueChanged)
        refreshControl.bounds = CGRect(x: refreshControl.bounds.origin.x,
                                       y: 0.0,
                                       width: refreshControl.bounds.size.width,
                                       height: refreshControl.bounds.size.height)
        return refreshControl
    }()
    
    lazy var activityIndicator : UIActivityIndicatorView = {
        
        var activityIndicator = UIActivityIndicatorView()
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.color = UIColor.blue
        if let viewWidth = self.collectionView?.frame.size.width,
            let yCoordinate = self.collectionView?.frame.origin.y {
            activityIndicator.frame = CGRect(x: (viewWidth/2 - 25),
                                             y: yCoordinate + 80,
                                             width: 50.0,
                                             height: 50.0)
        }
        
        return activityIndicator
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        collectionView?.addSubview(self.refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.reloadInputViews()
    }
    
    func setup() {
        
        if thumbnailsArray.count == 0 {
            
            DispatchQueue.main.async { [weak self] in
                if let activityIndicator = self?.activityIndicator {
                    self?.collectionView?.addSubview(activityIndicator)
                    activityIndicator.startAnimating()
                }
            }
        }
        
        imageManager.requestImages { (thumbnails) in
            print("Image manager completion")
            
            DispatchQueue.main.async { [weak self] in
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.removeFromSuperview()
            }
            
            if let thumbnails = thumbnails {
                self.thumbnailsArray = thumbnails
            }
        
        }
    }
}
