//
//  VIdeoCellView.swift
//  Bestsongs.pk
//
//  Created by IMac on 15/03/2018.
//  Copyright © 2018 Bestsongs. All rights reserved.
//

import UIKit



class VideoCellView : UICollectionViewCell {
    
   
    
    
    let videoThumbnailView : UIImageView = {
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "BestsongsPlaceholder")
        return imageView
        
    }()
    
    let videoTitleText : UILabel = {
        
        let title =  UILabel()
        title.text = "October 2018 (Trailllllllllllllllllllllllller)"
        title.numberOfLines = 1
        title.textColor = .white
        title.translatesAutoresizingMaskIntoConstraints = false
        
        return title
        
        
    }()
    
    let videoDescriptionText : UILabel = {
        
        let title =  UILabel()
        title.text = "Har Gana MilaygaMilaygaMilaygaMilaygaMilayga Yahan"
        title.numberOfLines = 1
        title.textColor = UIColor.init(red: 115/255, green: 115/255, blue: 115/255, alpha: 1)
        title.translatesAutoresizingMaskIntoConstraints = false
        
        return title
        
        
    }()
    
    
    let videoLikesView : UIView = {
        
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        
        return view
        
    }()
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        
    
        
        backgroundColor = .darkGray
        
       setupVideoCellView()
        
    }
    
    func setupVideoCellView() {
        
       
        
        addSubview(videoThumbnailView)
        
     
         let videoThumbnailViewLeftPadding = self.frame.width * 0.05
        
        videoThumbnailView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        videoThumbnailView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        videoThumbnailView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: videoThumbnailViewLeftPadding).isActive = true
        videoThumbnailView.widthAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        
        
        addSubview(videoTitleText)
        
        let videoTitleTextWidth = self.frame.width - self.frame.height - (self.frame.width * 0.05) - 16
        
        videoTitleText.widthAnchor.constraint(equalToConstant: videoTitleTextWidth).isActive = true
        videoTitleText.topAnchor.constraint(equalTo: videoThumbnailView.topAnchor, constant: 12).isActive = true
        videoTitleText.leftAnchor.constraint(equalTo: videoThumbnailView.rightAnchor, constant: 8).isActive = true
        
        
        addSubview(videoDescriptionText)
        
        
        
        let videoDescriptionTextWidth = self.frame.width - self.frame.height - (self.frame.width * 0.05) - 16
        
        videoDescriptionText.widthAnchor.constraint(equalToConstant: videoDescriptionTextWidth).isActive = true
        videoDescriptionText.topAnchor.constraint(equalTo: videoTitleText.bottomAnchor, constant: 0).isActive = true
        videoDescriptionText.leftAnchor.constraint(equalTo: videoThumbnailView.rightAnchor, constant: 8).isActive = true
        
        
   
        
        
        }
    
    
    
    
    
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
}

