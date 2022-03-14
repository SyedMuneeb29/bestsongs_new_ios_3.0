//
//  VideoCollectionCells.swift
//  VideoCollectionViews
//
//  Created by Syed Muneeb Ur Rehman on 27/05/2019.
//  Copyright © 2019 Syed Muneeb Ur Rehman. All rights reserved.
//

import UIKit




@objc class VideoCell : UICollectionViewCell {
    
   @objc var itemImage : CustomUIImageView!
   @objc var itemAlbumName : UILabel!
   @objc var itemTitleName : UILabel! ; @objc var itemDate : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubView()
        layoutSubView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override open var isSelected: Bool{
        set {
            
        }
        
        get {
            return super.isSelected
        }
    }
    
    override open var isHighlighted: Bool{
        set {
            
        }
        
        get {
            return super.isHighlighted
        }
    }
    
    
}

extension VideoCell {
    
    func setupSubView () {
        
        let uiProvider = GiveMeAUIProvider()
        
        itemImage = uiProvider.customImageView(withSetting:
            GiveMeAUIProvider.SettingsForUIImageView(
                image: ThemeImageConstants.HomeViewCarouselItemImageDummyImageConstant,
                isUserInteractionEnabled: false,
                isHighlighted: false,
                highlightedImage: nil,
                animationImages: nil,
                highlightedAnimationImages: nil,
                animationDuration: nil,
                animationRepeatCount: nil,
                startAnimating: nil,
                stopAnimating: nil,
                tintColor: nil,
                contentMode: UIView.ContentMode.scaleAspectFill)
        )
        
        
        itemAlbumName = uiProvider.customUILabel(withSetting:
            GiveMeAUIProvider.SettingsForUILabel(
                text: "Sun Re Sajaniya",
                font: ThemeFontConstant.HomeViewCarouselItemNameLabelFontConstant,
                textColor: ThemeColorConstants.HomeViewCarouselItemNameLabelColorConstant,
                shadowColor: nil,
                shadowOffset: nil,
                textAlignment: .left,
                lineBreakMode: NSLineBreakMode.byWordWrapping,
                highlightedTextColor: nil,
                isHighlighted: nil,
                numberOfLines: 2,
                adjustFontSizeToWidth: false)
        )
        
    
        
        itemTitleName = uiProvider.customUILabel(withSetting:
            GiveMeAUIProvider.SettingsForUILabel(
                text: "78K Views",
                font: ThemeFontConstant.HomeViewCarouselItemViewsLabelFontConstant,
                textColor: ThemeColorConstants.HomeViewCarouselItemViewsLabelColorConstant,
                shadowColor: nil,
                shadowOffset: nil,
                textAlignment: .left,
                lineBreakMode: NSLineBreakMode.byTruncatingTail,
                highlightedTextColor: nil,
                isHighlighted: nil,
                numberOfLines: 1,
                adjustFontSizeToWidth: false)
        )
        
        itemDate = uiProvider.customUILabel(withSetting:
            GiveMeAUIProvider.SettingsForUILabel(
                text: "1 Year Ago",
                font: ThemeFontConstant.HomeViewCarouselItemDateLabelFontConstant,
                textColor: ThemeColorConstants.HomeViewCarouselItemDateLabelColorConstant,
                shadowColor: nil,
                shadowOffset: nil,
                textAlignment: .left,
                lineBreakMode: NSLineBreakMode.byTruncatingTail,
                highlightedTextColor: nil,
                isHighlighted: nil,
                numberOfLines: 1,
                adjustFontSizeToWidth: false)
        )
        
    }
    
    func layoutSubView () {
        
        addSubview(itemImage)
        
        itemImage.addViewWith2(
            left: leftAnchor,
            top: topAnchor,
            right: nil,
            bottom: nil,
            height: heightAnchor,
            width: heightAnchor,
            centerX: nil,
            centerY: nil,
            constants: UIViewConstants(LeftConstant: 8,
                                       TopConstant: nil ,
                                       RightConstant: nil,
                                       BottomConstant: nil,
                                       HeightConstant: nil,
                                       WidthConstant: nil,
                                       CenterXConstant: nil,
                                       CenterYConstant: nil),
            multipliers: UIViewMultipliers(
                HeightMultiplier: 1,
                WidthMultiplier: 1)
        )
        
        addSubview(itemAlbumName)
        
        let height = itemAlbumName.intrinsicContentSize.height * 2
        
        itemAlbumName.addViewWith(
            left: itemImage.rightAnchor,
            top: topAnchor,
            right: rightAnchor,
            bottom: nil,
            height: height,
            width: nil,
            centerX: nil,
            centerY: nil,
            constants: UIViewConstants(LeftConstant: 8,
                                       TopConstant: nil,
                                       RightConstant: nil,
                                       BottomConstant: nil,
                                       HeightConstant: nil,
                                       WidthConstant: nil,
                                       CenterXConstant: nil,
                                       CenterYConstant: nil))
        
        addSubview(itemTitleName)
        
        itemTitleName.addViewWith(
            left: itemImage.rightAnchor,
            top: itemAlbumName.bottomAnchor,
            right: rightAnchor,
            bottom: nil,
            height: height,
            width: nil,
            centerX: nil,
            centerY: nil,
            constants: UIViewConstants(LeftConstant: 8,
                                       TopConstant: nil,
                                       RightConstant: nil,
                                       BottomConstant: nil,
                                       HeightConstant: nil,
                                       WidthConstant: nil,
                                       CenterXConstant: nil,
                                       CenterYConstant: nil))
        

        
    }
    
    
}


