//
//  ViewLibraries.swift
//  Bestsongs.pk
//
//  Created by Syed Muneeb Ur Rehman on 17/06/2019.
//  Copyright © 2019 Bestsongs. All rights reserved.
//

import UIKit

class ViewLibrary : NSObject {
    
    
    
    
    
    
}

// Custom Slider
extension ViewLibrary {
    
    
    
    enum SlidingCollectionView : Int {
        case CollectionView = 1
        case PageControl
    }
    
    func slidingCollectionView () -> EmptyUIView {
        
        let view : EmptyUIView = {
            
            let view = EmptyUIView()
            view.backgroundColor = .orange
            return view
            
        }()
        
        let pager : UIPageControl = {
            
            let pager = UIPageControl()
            pager.numberOfPages = 7
            pager.currentPage = 0
            // pager.backgroundColor = UIColor.init(red: 15 / 255 , green: 15 / 255 , blue: 15 / 255 , alpha: 0.2)
            pager.currentPageIndicatorTintColor =  UIColor.init(red: 255 / 255 , green: 47 / 255 , blue: 146 / 255 , alpha: 1)
            pager.pageIndicatorTintColor = UIColor.init(red: 184 / 255 , green: 184 / 255 , blue: 184 / 255 , alpha: 0.3)
            pager.translatesAutoresizingMaskIntoConstraints = false
            return pager
            
        }()
        
        
        
        
        let collectionView = GiveMeACollectionView()
        
        
        setupSlidingCollectionView(collectionView: collectionView, sliderURLsOrSliderImage: nil , pager : UIPageControl() )
        
        collectionView.tag = SlidingCollectionView.CollectionView.rawValue
        pager.tag = SlidingCollectionView.PageControl.rawValue
        
        view.addSubview(collectionView)
        
        view.addSubview(pager)
        
        collectionView.addViewWith2(
            left: nil,
            top: nil,
            right: nil,
            bottom: nil,
            height: view.heightAnchor,
            width: view.widthAnchor,
            centerX: view.centerXAnchor,
            centerY: view.centerYAnchor,
            constants: UIViewConstants(LeftConstant: nil,
                                       TopConstant: nil,
                                       RightConstant: nil,
                                       BottomConstant: nil,
                                       HeightConstant: nil,
                                       WidthConstant: nil,
                                       CenterXConstant: nil,
                                       CenterYConstant: nil),
            multipliers: UIViewMultipliers(
                HeightMultiplier: 1,
                WidthMultiplier: 1 )
        )
        
        
        pager.addViewWith(
            left: view.leftAnchor,
            top: nil,
            right: view.rightAnchor,
            bottom: collectionView.bottomAnchor,
            height: 25,
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
                CenterYConstant: nil)
        )
        
        
        
        return view
        
    }
    
    func setupPager ( pager : UIPageControl , numberOfPages : Int , currentPageColor : UIColor , pageColor : UIColor , backgroundColor : UIColor ) {
        
        pager.numberOfPages = numberOfPages
        pager.currentPage = 0
        pager.backgroundColor = backgroundColor
        pager.currentPageIndicatorTintColor = currentPageColor
        pager.pageIndicatorTintColor = pageColor
        
    }
    
    func setupSlidingCollectionView ( collectionView : GiveMeACollectionView , sliderURLsOrSliderImage : [Any]?  , pager : UIPageControl) {
        
        
        collectionView.closureForDisplayedCell = { collectionView , indexPath , cell in
            
            pager.currentPage = indexPath.item
            
        }
        
        collectionView.setupCollectionView(
            havingLayout: collectionView.generatelayout(
                havingScrollDirection: .horizontal,
                interimSpacing: 0,
                lineSpacing: 0),
            spaceBetweenSections: ThemeSizeConstants.SlidingCollectionViewSpaceBetweenItemsSizeConstant,
            numberOfSections: 1,
            numberOfItemsInSection: [ 1 : sliderURLsOrSliderImage?.count ?? 3 ],
            sizeForCellAtIndexPath: nil,
            orSizeForAllCells: CGSize(
                width: ThemeSizeConstants.ScreenWidthSizeConstant ,
                height: ThemeSizeConstants.ScreenWidthSizeConstant * (9 / 16)
            ),
            cellsToBeRegisteredInCollectionView: ["slidingCollectionViewCell" : SlidingCollectionViewCell.self ],
            cellForItemAt: { (collectionView, indexPath) -> UICollectionViewCell in
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "slidingCollectionViewCell", for: indexPath) as! SlidingCollectionViewCell
                
                if let sliderURLsOrSliderImage = sliderURLsOrSliderImage {
                    
                    if let sliderUrls = sliderURLsOrSliderImage[indexPath.item] as? URL {
                        cell.imageURL = sliderUrls
                    }
                    else if let sliderUrls = sliderURLsOrSliderImage[indexPath.item] as? NSString {
                        cell.imageURL = URL(string: String(sliderUrls))!
                    }
                    else if let sliderImage = sliderURLsOrSliderImage[indexPath.item] as? UIImage{
                        cell.imageView.image = sliderImage
                    }
                    
                    
                }
                cell.backgroundColor = .orange
                return cell
                
        },
            didSelectItemAt: nil,
            didDeSelectItemAt: nil )
        
        collectionView.collectionView.backgroundColor = ThemeColorConstants.SlidingCollectionViewBackgroundColor
        collectionView.collectionView.showsHorizontalScrollIndicator = false
        collectionView.collectionView.isPagingEnabled = true
        
    }
    
    func setupCollectionViewAndPagerAsSliding (noOfSlides : Int , collectionViewHolder : GiveMeACollectionView ) {
        
        var scrollDirection = UICollectionView.ScrollPosition.right
        
        if ( noOfSlides > 0 ){
            
            Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { (timer) in
             
                if collectionViewHolder.collectionView.indexPathsForVisibleItems.count != 0 {
             
                    let indexPathsForVisibleItems = collectionViewHolder.collectionView.indexPathsForVisibleItems
                    var itemToScrollTo = ( indexPathsForVisibleItems.first?.item )! + 1
                    
                    if itemToScrollTo > noOfSlides - 1 {
                        itemToScrollTo = 0  ;
                        scrollDirection = UICollectionView.ScrollPosition.left
                    }
                    else {
                        scrollDirection = UICollectionView.ScrollPosition.right
                    }
                    
                    collectionViewHolder.collectionView.scrollToItem(
                        at: IndexPath(item: itemToScrollTo, section: 0),
                        at: scrollDirection,
                        animated: true
                    )
//                    let currentPage = itemToScrollTo
//                    pager.currentPage = currentPage
                }
            }
        }
        
        
    }
    
    
    
    
    
    
}
