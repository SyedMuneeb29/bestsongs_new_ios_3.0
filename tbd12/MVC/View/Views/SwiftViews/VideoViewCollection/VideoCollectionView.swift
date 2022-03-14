//
//  VideoCollectionView.swift
//  Bestsongs.pk
//
//  Created by Zohaib Ahmed on 10/03/2018.
//  Copyright © 2018 Bestsongs. All rights reserved.
//

import UIKit


class VideoViewCollection :UIView,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
   
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .black
        
        collectionViewVideos.register(VideoCellView.self, forCellWithReuseIdentifier: identifierForVideoCell)
  
        setupVideoPlayer()
        
    }
    
   
    
    
    
    let identifierForVideoCell = "cellIdentifier"
    
    lazy var collectionViewVideos: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
     
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionViewVideos.dequeueReusableCell(withReuseIdentifier: identifierForVideoCell, for: indexPath) as? VideoCellView
        
        
   
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellVideoHeight = collectionViewVideos.frame.height * 0.40
        
             return CGSize(width: collectionViewVideos.frame.width, height: cellVideoHeight)
     
            }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    
    func setupVideoPlayer() {
     
        self.addSubview(collectionViewVideos)
        
        
        collectionViewVideos.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        collectionViewVideos.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        collectionViewVideos.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        collectionViewVideos.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        

    
    }
    
    
    
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

