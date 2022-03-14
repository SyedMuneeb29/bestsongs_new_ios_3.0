//
//  ViewLibraryCells.swift
//  Bestsongs.pk
//
//  Created by Syed Muneeb Ur Rehman on 17/06/2019.
//  Copyright © 2019 Bestsongs. All rights reserved.
//

import UIKit


class SlidingCollectionViewCell : UICollectionViewCell {
    
    var imageURL : URL {
        get { return URL(string: "https://www.google.com")! }
        set {
            imageView.loadImageWith(url: newValue)
        }
    }
    var imageView : CustomUIImageView!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubViews()
        layoutSubViews()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// SubViews methods
extension SlidingCollectionViewCell {
    
    func setupSubViews () {
        
        let uiProvider = GiveMeAUIProvider()
        
        imageView = uiProvider.customImageView(withSetting:
            GiveMeAUIProvider.SettingsForUIImageView(
                image: ThemeImageConstants.SlidingCollectionViewPlaceholderImageConstant,
                isUserInteractionEnabled: true ,
                isHighlighted: false,
                highlightedImage: nil,
                animationImages: nil,//<#T##[UIImage]?#>,
                highlightedAnimationImages: nil,
                animationDuration: nil,//<#T##TimeInterval?#>,
                animationRepeatCount: nil,//<#T##Int?#>,
                startAnimating: nil,
                stopAnimating: nil,
                tintColor: nil,
                contentMode: UIView.ContentMode.scaleToFill)
        )
        
        
    }
    func layoutSubViews () {
        
        addSubview(imageView)
        
        imageView.addViewWith2(
            left: leftAnchor,
            top: topAnchor,
            right: rightAnchor,
            bottom: bottomAnchor,
            height: nil,
            width: nil,
            centerX: nil,
            centerY: nil,
            constants: UIViewConstants(
                LeftConstant: nil,
                TopConstant: nil,
                RightConstant: nil,
                BottomConstant: nil,
                HeightConstant: nil,
                WidthConstant: nil,
                CenterXConstant: nil,
                CenterYConstant: nil),
            multipliers: UIViewMultipliers(
                HeightMultiplier: nil,
                WidthMultiplier: nil)
        )
        
        
    }
    
}



