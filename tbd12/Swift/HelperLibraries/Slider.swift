//
//  Slider.swift
//  Bestsongs.pk
//
//  Created by Syed Muneeb Ur Rehman on 17/06/2019.
//  Copyright © 2019 Bestsongs. All rights reserved.
//

import UIKit


@objc class MainSlider : EmptyUIView {
    
    var viewLibrary : ViewLibrary!
    var slider : EmptyUIView!
    var collectionView : GiveMeACollectionView!
    var pager : UIPageControl!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewLibrary = ViewLibrary()
        
        slider = viewLibrary.slidingCollectionView()
        collectionView = (slider.viewWithTag(ViewLibrary.SlidingCollectionView.CollectionView.rawValue) as! GiveMeACollectionView)
        pager = (slider.viewWithTag(ViewLibrary.SlidingCollectionView.PageControl.rawValue) as! UIPageControl)
        
        addSubview(slider)
        
        slider.addViewWith(left: leftAnchor,
                           top: topAnchor,
                           right: rightAnchor,
                           bottom: bottomAnchor,
                           height: nil,
                           width: nil,
                           centerX: nil,
                           centerY: nil,
                           constants: UIViewConstants(LeftConstant: nil,
                                                      TopConstant: nil,
                                                      RightConstant: nil,
                                                      BottomConstant: nil,
                                                      HeightConstant: nil,
                                                      WidthConstant: nil,
                                                      CenterXConstant: nil,
                                                      CenterYConstant: nil))
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func setupSlider(withSliderUrlsOrUIImages sliderData: [Any]) {
        viewLibrary.setupSlidingCollectionView(collectionView: collectionView, sliderURLsOrSliderImage: sliderData, pager: pager)
        viewLibrary.setupCollectionViewAndPagerAsSliding(noOfSlides: sliderData.count, collectionViewHolder: collectionView)
    }
    
  
    @objc func refreshSlider(withSliderData sliderData: [Any]) {
        viewLibrary.setupSlidingCollectionView(collectionView: collectionView, sliderURLsOrSliderImage: sliderData, pager: pager)
    }
    
    
}
