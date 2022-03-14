//
//  CustomUIView.swift
//  Takkuu
//
//  Created by Suunnoo Team on 1/3/19.
//  Copyright © 2019 EwicanTech. All rights reserved.
//

import Foundation
import UIKit


/**
 # UICollectionViewCell #
 GiveMeACustomUIView is a customized generalized view in which
 the placements of its inner subchilds are done in way which is made to make the process convenient to you
 
 - Three Primary layers : Firstly it consists of three layers that are to be layed out all together in either vertical or horizontal way , these layers are discused as follows :
 
 -------
 - Top layer : sada
 -------
 -------
 - Top layer : sada
 -------
 -------
 - Top layer : sada
 -------
 
 ``````
 About Weights :
 ``````
 
 */

class CustomUIView : EmptyUIView {
    //
    //    var imagesHoldingView = ViewForImages()
    //    var textHoldingView = ViewForTexts()
    //    var buttonsHoldingView = ViewForButtons()
    
    
    lazy var heightForTopViews : CGFloat  = frame.size.height / 3
    lazy var heightForMiddleViews : CGFloat  = frame.size.height / 3
    lazy var heightForBottomViews : CGFloat  = frame.size.height / 3
    
    
    enum Orientation {
        case Horizontal
        case Vertical
    }
    
    var topViewOrientation = Orientation.Horizontal
    var middleViewOrientation = Orientation.Horizontal
    var bottomViewOrientation = Orientation.Horizontal
    
    struct Item {
        let View : EmptyUIView
        let Ratio : CGFloat
    }
    
    var arrayOfViewsToBeAddedInTopView : [Item] = [Item]()
    var arrayOfViewsToBeAddedInMiddleView : [Item] = [Item]()
    var arrayOfViewsToBeAddedInBottomView : [Item] = [Item]()
    
    
    
    
    var topView : UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var middleView : UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var bottomView : UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    func setWeights (forTopView topWeight : CGFloat ,forMiddleView middleWeight : CGFloat,forBottomView bottomWeight : CGFloat){
        
        let totalWeight = topWeight + middleWeight + bottomWeight
        heightForTopViews = (frame.size.height * topWeight ) / totalWeight
        heightForMiddleViews = (frame.size.height * middleWeight ) / totalWeight
        heightForBottomViews = (frame.size.height * bottomWeight ) / totalWeight
        
        setNeedsLayout()
        
    }
    
    
    func setOrientations (forTopView topOrientation : Orientation ,forMiddleView middleOrientation : Orientation,forBottomView bottomOrientation : Orientation){
        
        topViewOrientation = topOrientation
        middleViewOrientation = middleOrientation
        bottomViewOrientation = bottomOrientation
        
        setNeedsLayout()
    }
    
    
    
    func provideItemsAndTheirRatios (forTopView topItems : [Item] ,forMiddleView middleItems : [Item] ,forBottomView bottomItems : [Item]){
        
        
        //        let topViewHeight = heightForTopViews
        //        let MiddleViewHeight = heightForMiddleViews
        //        let BottomViewHeight = heightForBottomViews
        //
        
        let totalWidthOfEitherTopMiddleOrBottomView : CGFloat = frame.size.width
        
        let totalRatioForTopViewItems : CGFloat = {
            var totalRatio : CGFloat = 0
            for item in topItems{
                totalRatio = totalRatio + item.Ratio
            }
            return totalRatio
        }()
        let totalRatioForMiddleViewItems : CGFloat = {
            var totalRatio : CGFloat = 0
            for item in middleItems{
                totalRatio = totalRatio + item.Ratio
            }
            return totalRatio
        }()
        let totalRatioForBottomViewItems : CGFloat = {
            var totalRatio : CGFloat = 0
            for item in bottomItems{
                totalRatio = totalRatio + item.Ratio
            }
            return totalRatio
        }()
        
        
        
        
        for (index,item) in topItems.enumerated() {
            
            switch (topViewOrientation){
                
            case .Horizontal :
                
                let widthForItemToBePlaced : CGFloat = (totalWidthOfEitherTopMiddleOrBottomView * item.Ratio) / totalRatioForTopViewItems
                
                
                
                let constantsForItemsInTopView = UIViewConstants(LeftConstant: nil,
                                                                 TopConstant: nil,
                                                                 RightConstant: nil,
                                                                 BottomConstant: nil,
                                                                 HeightConstant: nil,
                                                                 WidthConstant: nil,
                                                                 CenterXConstant: nil,
                                                                 CenterYConstant: nil)
                
                
                
                
                
                if index == 0 {
                    
                    topView.addSubview(item.View)
                    item.View.addViewWith(left: topView.leftAnchor,
                                          top: topView.topAnchor,
                                          right: nil,
                                          bottom: topView.bottomAnchor,
                                          height: nil,
                                          width: widthForItemToBePlaced,
                                          centerX: nil,
                                          centerY: nil,
                                          constants: constantsForItemsInTopView)
                }
                else{
                    
                    
                    topView.addSubview(item.View)
                    item.View.addViewWith(left: topItems[index - 1].View.rightAnchor,
                                          top: topView.topAnchor,
                                          right: nil,
                                          bottom: topView.bottomAnchor,
                                          height: nil,
                                          width: widthForItemToBePlaced,
                                          centerX: nil,
                                          centerY: nil,
                                          constants: constantsForItemsInTopView)
                    
                    
                }
            ////////////////////////////////////
            case .Vertical :
                
                let heightForItemToBePlaced : CGFloat = (heightForTopViews * item.Ratio) / totalRatioForTopViewItems
                
                
                
                let constantsForItemsInMiddleView = UIViewConstants(LeftConstant: nil,
                                                                    TopConstant: nil,
                                                                    RightConstant: nil,
                                                                    BottomConstant: nil,
                                                                    HeightConstant: nil,
                                                                    WidthConstant: nil,
                                                                    CenterXConstant: nil,
                                                                    CenterYConstant: nil)
                
                
                if index == 0 {
                    
                    topView.addSubview(item.View)
                    item.View.addViewWith(left: topView.leftAnchor,
                                          top: topView.topAnchor,
                                          right: topView.rightAnchor,
                                          bottom: nil,
                                          height: heightForItemToBePlaced,
                                          width: nil,
                                          centerX: nil,
                                          centerY: nil,
                                          constants: constantsForItemsInMiddleView)
                }
                else{
                    
                    
                    topView.addSubview(item.View)
                    item.View.addViewWith(left: topView.leftAnchor,
                                          top: topItems[index - 1].View.bottomAnchor,
                                          right: topView.rightAnchor,
                                          bottom:nil,
                                          height: heightForItemToBePlaced,
                                          width: nil,
                                          centerX: nil,
                                          centerY: nil,
                                          constants: constantsForItemsInMiddleView)
                    
                    
                }
                
                
                
                print("topViewOrientationUnknown")
            }
            
        }
        
        for (index,item) in middleItems.enumerated() {
            
            switch (middleViewOrientation){
                
            case .Horizontal :
                
                let widthForItemToBePlaced : CGFloat = (totalWidthOfEitherTopMiddleOrBottomView * item.Ratio) / totalRatioForMiddleViewItems
                
                
                
                let constantsForItemsInMiddleView = UIViewConstants(LeftConstant: nil,
                                                                    TopConstant: nil,
                                                                    RightConstant: nil,
                                                                    BottomConstant: nil,
                                                                    HeightConstant: nil,
                                                                    WidthConstant: nil,
                                                                    CenterXConstant: nil,
                                                                    CenterYConstant: nil)
                
                
                if index == 0 {
                    
                    middleView.addSubview(item.View)
                    item.View.addViewWith(left: middleView.leftAnchor,
                                          top: middleView.topAnchor,
                                          right: nil,
                                          bottom: middleView.bottomAnchor,
                                          height: nil,
                                          width: widthForItemToBePlaced,
                                          centerX: nil,
                                          centerY: nil,
                                          constants: constantsForItemsInMiddleView)
                }
                else{
                    
                    
                    middleView.addSubview(item.View)
                    item.View.addViewWith(left: middleItems[index - 1].View.rightAnchor,
                                          top: middleView.topAnchor,
                                          right: nil,
                                          bottom: middleView.bottomAnchor,
                                          height: nil,
                                          width: widthForItemToBePlaced,
                                          centerX: nil,
                                          centerY: nil,
                                          constants: constantsForItemsInMiddleView)
                    
                    
                }
            ////////////////////////////////////
            case .Vertical :
                
                let heightForItemToBePlaced : CGFloat = (heightForMiddleViews * item.Ratio) / totalRatioForMiddleViewItems
                
                
                
                let constantsForItemsInMiddleView = UIViewConstants(LeftConstant: nil,
                                                                    TopConstant: nil,
                                                                    RightConstant: nil,
                                                                    BottomConstant: nil,
                                                                    HeightConstant: nil,
                                                                    WidthConstant: nil,
                                                                    CenterXConstant: nil,
                                                                    CenterYConstant: nil)
                
                
                if index == 0 {
                    
                    middleView.addSubview(item.View)
                    item.View.addViewWith(left: middleView.leftAnchor,
                                          top: middleView.topAnchor,
                                          right: middleView.rightAnchor,
                                          bottom: nil,
                                          height: heightForItemToBePlaced,
                                          width: nil,
                                          centerX: nil,
                                          centerY: nil,
                                          constants: constantsForItemsInMiddleView)
                }
                else{
                    
                    
                    middleView.addSubview(item.View)
                    item.View.addViewWith(left: middleView.leftAnchor,
                                          top: middleItems[index - 1].View.bottomAnchor,
                                          right: middleView.rightAnchor,
                                          bottom:nil,
                                          height: heightForItemToBePlaced,
                                          width: nil,
                                          centerX: nil,
                                          centerY: nil,
                                          constants: constantsForItemsInMiddleView)
                    
                    
                }
                
                print("topViewOrientationUnknown")
            }
            
        }
        
        for (index,item) in bottomItems.enumerated() {
            
            switch (bottomViewOrientation){
                
            case .Horizontal :
                
                let widthForItemToBePlaced : CGFloat = (totalWidthOfEitherTopMiddleOrBottomView * item.Ratio) / totalRatioForBottomViewItems
                
                
                
                let constantsForItemsInBottomView = UIViewConstants(LeftConstant: nil,
                                                                    TopConstant: nil,
                                                                    RightConstant: nil,
                                                                    BottomConstant: nil,
                                                                    HeightConstant: nil,
                                                                    WidthConstant: nil,
                                                                    CenterXConstant: nil,
                                                                    CenterYConstant: nil)
                
                
                
                
                
                if index == 0 {
                    
                    bottomView.addSubview(item.View)
                    item.View.addViewWith(left: bottomView.leftAnchor,
                                          top: bottomView.topAnchor,
                                          right: nil,
                                          bottom: bottomView.bottomAnchor,
                                          height: nil,
                                          width: widthForItemToBePlaced,
                                          centerX: nil,
                                          centerY: nil,
                                          constants: constantsForItemsInBottomView)
                }
                else{
                    
                    
                    bottomView.addSubview(item.View)
                    item.View.addViewWith(left: bottomItems[index - 1].View.rightAnchor,
                                          top: bottomView.topAnchor,
                                          right: nil,
                                          bottom: bottomView.bottomAnchor,
                                          height: nil,
                                          width: widthForItemToBePlaced,
                                          centerX: nil,
                                          centerY: nil,
                                          constants: constantsForItemsInBottomView)
                    
                    
                }
            ////////////////////////////////////
            case .Vertical :
                
                let heightForItemToBePlaced : CGFloat = (heightForBottomViews * item.Ratio) / totalRatioForBottomViewItems
                
                
                
                let constantsForItemsInMiddleView = UIViewConstants(LeftConstant: nil,
                                                                    TopConstant: nil,
                                                                    RightConstant: nil,
                                                                    BottomConstant: nil,
                                                                    HeightConstant: nil,
                                                                    WidthConstant: nil,
                                                                    CenterXConstant: nil,
                                                                    CenterYConstant: nil)
                
                
                if index == 0 {
                    
                    bottomView.addSubview(item.View)
                    item.View.addViewWith(left: bottomView.leftAnchor,
                                          top: bottomView.topAnchor,
                                          right: bottomView.rightAnchor,
                                          bottom: nil,
                                          height: heightForItemToBePlaced,
                                          width: nil,
                                          centerX: nil,
                                          centerY: nil,
                                          constants: constantsForItemsInMiddleView)
                }
                else{
                    
                    
                    bottomView.addSubview(item.View)
                    item.View.addViewWith(left: bottomView.leftAnchor,
                                          top: bottomItems[index - 1].View.bottomAnchor,
                                          right: bottomView.rightAnchor,
                                          bottom:nil,
                                          height: heightForItemToBePlaced,
                                          width: nil,
                                          centerX: nil,
                                          centerY: nil,
                                          constants: constantsForItemsInMiddleView)
                    
                    
                }
                
                
                print("topViewOrientationUnknown")
            }
            
        }
        
        //        for item in middleItems {
        //
        //            switch (middleViewOrientation){
        //            case .Horizontal :
        //                print("topViewOrientationUnknown")
        //            case .Vertical :
        //                print("topViewOrientationUnknown")
        //            }
        //
        //        }
        //        for item in bottomItems {
        //
        //            switch (bottomViewOrientation){
        //            case .Horizontal :
        //                print("topViewOrientationUnknown")
        //            case .Vertical :
        //                print("topViewOrientationUnknown")
        //            }
        //
        //        }
        
    }
    
    
    
    
    
    
    
    
    
    //
    //    func addToTopView() {
    //
    //        var count = 0
    //
    //        if imagesHoldingView.position == 0 {count += count}
    //        if textHoldingView.position == 0 {count += count}
    //        if buttonsHoldingView.position == 0 {count += count}
    //
    //        for i in 1...count {
    //            print(i)
    //        }
    //
    //    }
    //    func addToMiddleView() {
    //        var count = 0
    //
    //        if imagesHoldingView.position == 0 {count += count}
    //        if textHoldingView.position == 0 {count += count}
    //        if buttonsHoldingView.position == 0 {count += count}
    //
    //        for i in 1...count {
    //            print(i)
    //        }
    //    }
    //    func addToBottomView() {
    //        var count = 0
    //
    //        if imagesHoldingView.position == 0 {count += count}
    //        if textHoldingView.position == 0 {count += count}
    //        if buttonsHoldingView.position == 0 {count += count}
    //
    //        for i in 1...count {
    //            print(i)
    //        }
    //    }
    //
    //
    
    
    
    override func layoutSubviews() {
        
        
        
        
        let constantsForViewsOfCustomCell = UIViewConstants(LeftConstant: nil,
                                                            TopConstant: nil,
                                                            RightConstant: nil,
                                                            BottomConstant: nil,
                                                            HeightConstant: nil,
                                                            WidthConstant: nil,
                                                            CenterXConstant: nil,
                                                            CenterYConstant: nil)
        
        addSubview(topView)
        topView.addViewWith(left: leftAnchor,
                            top: topAnchor,
                            right: rightAnchor,
                            bottom: nil,
                            height: heightForTopViews,
                            width: nil,
                            centerX: nil,
                            centerY: nil,
                            constants: constantsForViewsOfCustomCell)
        
        addSubview(middleView)
        middleView.addViewWith(left: leftAnchor,
                               top: topView.bottomAnchor,
                               right: rightAnchor,
                               bottom: nil,
                               height: heightForMiddleViews,
                               width: nil,
                               centerX: nil,
                               centerY: nil,
                               constants: constantsForViewsOfCustomCell)
        
        addSubview(bottomView)
        bottomView.addViewWith(left: leftAnchor,
                               top: middleView.bottomAnchor,
                               right: rightAnchor,
                               bottom: nil,
                               height: heightForBottomViews,
                               width: nil,
                               centerX: nil,
                               centerY: nil,
                               constants: constantsForViewsOfCustomCell)
        
        
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame : frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print ("UICollectionViewCustomCell is De inititalized")
    }
    
    
    
    
    
    
    
}
















//
//class ViewForImages : UIView {
//
//    var position = 0
//
//}
//
//class ViewForTexts : UIView {
//    var position = 0
//}
//
//
//class ViewForButtons : UIView {
//    var position = 0
//
//}
//
//class CustomImageViewForCell : UIImageView {
//
//}
//class CustomTextViewForCell : UITextView {
//
//}
//class CustomButtonViewForCell : UIButton {
//
//}
