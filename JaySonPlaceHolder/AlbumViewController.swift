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
    let multiplier = 12
    var randomCellSize: Int = 10
    var randomPadding: Int = 0
    var requestInProgress : Bool = false
    
    var thumbnailsArray : ThumbnailsDataArray = [] {
        didSet {
            randomCellSize = self.RandomInt(min: 10, max: 90)
            randomPadding = self.RandomInt(min: -8, max: 10)
            
            if randomPadding > (randomCellSize/2 - 5) {
                randomPadding = randomCellSize/2 - 5
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.collectionView?.reloadData()
            }
        }
    }
    
    var randomAlbum : Int {
        get {
            return Int(arc4random_uniform(UInt32(100))) + 1
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.orange
        refreshControl.addTarget(self, action: #selector(initiateRequest), for: .valueChanged)
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
        setupKaleidoscope()
        collectionView?.addSubview(self.refreshControl)
    }
    
    
    // MARK: Private functions
    
    func setupKaleidoscope() {
        DispatchQueue.main.async { [weak self] in
            if let activityIndicator = self?.activityIndicator {
                self?.collectionView?.addSubview(activityIndicator)
                activityIndicator.startAnimating()
            }
        }
        initiateRequest()
    }
    
    func initiateRequest () {
        if self.requestInProgress != true {
            self.requestInProgress = true
            imageManager.requestImages(random: randomAlbum) {  [weak self] (thumbnails) in
                
                DispatchQueue.main.async { [weak self] in
                    if self?.activityIndicator.isAnimating == true {
                        self?.activityIndicator.stopAnimating()
                        self?.activityIndicator.removeFromSuperview()
                    }
                    self?.refreshControl.endRefreshing()
                }
                
                if let thumbnails = thumbnails {
                    self?.thumbnailsArray = thumbnails
                    self?.requestInProgress = false
                }
            }
        }
    }
    
    private func RandomInt(min: Int, max: Int) -> Int {
        if max < min { return min }
        return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
    }
    
    @IBAction private func refreshButtonTapped(_ sender: AnyObject) {
        setupKaleidoscope()
    }
    
}
