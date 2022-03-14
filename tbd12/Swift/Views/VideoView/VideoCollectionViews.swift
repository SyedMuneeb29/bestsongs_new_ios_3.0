//
//  VideoCollectionViews.swift
//  VideoCollectionViews
//
//  Created by Syed Muneeb Ur Rehman on 27/05/2019.
//  Copyright © 2019 Syed Muneeb Ur Rehman. All rights reserved.
//

import UIKit



@objc protocol VideoCollectionViewDelegate : NSObjectProtocol {
    
    
    @available(iOS 6.0 , *)
    @objc func numberOfItems () -> Int
    
    @available(iOS 6.0 , *)
    @objc func collectionViewCellForItemAt (collectionView : UICollectionView , indexPath : IndexPath) -> UICollectionViewCell
    
    @available(iOS 6.0 , *)
    @objc func collectionViewDidSelectCell (collectionView : UICollectionView , indexPath : IndexPath)
    
}


@objc class VideoCollectionsView  : CustomUIView {
    
    let uiProvider = GiveMeAUIProvider()
    
    @objc weak var collectionViewsDelegate : VideoCollectionViewDelegate? {
        
        didSet {
            
             customInit()
            
        }
        
    }
    
    @objc var collectionView : GiveMeACollectionView!
    
    struct Weights {
        static var TopViewWeight : CGFloat!
        static var MiddleViewWeight : CGFloat!
        static var BottomViewWeight : CGFloat!
    }
    
    func setupWeights (
        forTopView topViewWeight : CGFloat ,
        forMiddleView middleViewWeight : CGFloat ,
        forBottomView bottomViewWeight : CGFloat  ) {
        
        Weights.TopViewWeight = topViewWeight
        Weights.MiddleViewWeight = middleViewWeight
        Weights.BottomViewWeight = bottomViewWeight
        
    }
    
    
    struct Orientations {
        static var TopViewOrientation : CustomUIView.Orientation!
        static var MiddleViewOrientation : CustomUIView.Orientation!
        static var BottomViewOrientation : CustomUIView.Orientation!
    }
    
    func setupOrientations (
        forTopView topViewOrientation : CustomUIView.Orientation ,
        forMiddleView middleViewOrientation : CustomUIView.Orientation ,
        forBottomView bottomViewOrientation : CustomUIView.Orientation ){
        
        Orientations.TopViewOrientation = topViewOrientation
        Orientations.MiddleViewOrientation = middleViewOrientation
        Orientations.BottomViewOrientation = bottomViewOrientation
        
    }
    
    
    
    struct Items {
        static var InTopView = [CustomUIView.Item]()
        static var InMiddleView = [CustomUIView.Item]()
        static var InBottomView = [CustomUIView.Item]()
    }
    
    struct ItemNames {
        static var InTopView = [String]()
        static var InMiddleView = [String]()
        static var InBottomView = [String]()
    }
    
    enum ViewType {
        
        case TopViewType
        case MiddleViewType
        case BottomViewType
        
    }
    
    func appendNewItem (
        inViewOfType type : ViewType ,
        AndItem item : CustomUIView.Item ,
        havingName name : String ) {
        
        switch type {
            
        case .TopViewType :
            Items.InTopView.append(item)
            ItemNames.InTopView.append(name)
            
        case .MiddleViewType :
            Items.InMiddleView.append(item)
            ItemNames.InMiddleView.append(name)
            
        case .BottomViewType :
            Items.InBottomView.append(item)
            ItemNames.InBottomView.append(name)
            
            
            
        }
        
    }
    
    func retrieveView ( fromItemType type : ViewType , withViewName name : String ) -> EmptyUIView {
        
        
        switch type {
        case .TopViewType:
            let index = ItemNames.InTopView.index(of: name) ?? 0
            let item = Items.InTopView[index]
            let view = item.View
            return view
            
        case .MiddleViewType :
            let index = ItemNames.InMiddleView.index(of: name) ?? 0
            let item = Items.InMiddleView[index]
            let view = item.View
            return view
            
        case .BottomViewType :
            let index = ItemNames.InBottomView.index(of: name) ?? 0
            let item = Items.InBottomView[index]
            let view = item.View
            return view
            
        }
        
        
    }
    
    
    func setupItems (forTopView topViewItems : [CustomUIView.Item] ,
                     forMiddleView middleViewItems : [CustomUIView.Item] ,
                     forBottomView bottomViewItems : [CustomUIView.Item] ) {
        
        Items.InTopView = topViewItems
        Items.InMiddleView = middleViewItems
        Items.InBottomView = bottomViewItems
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        
        setWeights(
            forTopView: Weights.TopViewWeight,
            forMiddleView: Weights.MiddleViewWeight,
            forBottomView: Weights.BottomViewWeight
        )
        
        setOrientations(
            forTopView: Orientations.TopViewOrientation,
            forMiddleView: Orientations.MiddleViewOrientation,
            forBottomView: Orientations.BottomViewOrientation
        )
        
        provideItemsAndTheirRatios(
            forTopView: Items.InTopView,
            forMiddleView: Items.InMiddleView,
            forBottomView: Items.InBottomView
        )
        
        
        
        
        super.layoutSubviews()
        
    }
    
    
    @objc func deInitialize () {
        
        Items.InTopView.removeAll()
        Items.InMiddleView.removeAll()
        Items.InBottomView.removeAll()
        
        ItemNames.InTopView.removeAll()
        ItemNames.InMiddleView.removeAll()
        ItemNames.InBottomView.removeAll()
        
        
        
    }
    
    
    deinit {

        deInitialize()
        
    }
    
}



extension VideoCollectionsView {
    
    // main callee
    
    func customInit() {
        
        topView.backgroundColor = UIColor.init(red: 1, green: 64 / 255 , blue: 129 / 255, alpha: 1)
        middleView.backgroundColor = .green
        bottomView.backgroundColor = .clear
        
        setupMainViewWeightAndOrientation()
        setupTopView()
        
    }
    
}



extension VideoCollectionsView {
    
    // setup main views
    
    func setupMainViewWeightAndOrientation() {
        
        setupWeights(
            forTopView: 1,
            forMiddleView: 0,
            forBottomView: 0
        )
        
        setupOrientations(
            forTopView: .Vertical,
            forMiddleView: .Vertical,
            forBottomView: .Vertical
        )
        
    }
    
    func setupTopView() {
        
        let name = "videoCollectionsView"
        let ratio : CGFloat = 1
        let view : EmptyUIView = {
            
            let view = EmptyUIView()
            view.backgroundColor = .clear
            return view
            
        }()
        
        let videoCollectionView = videosCollectionView()
        
        
        view.addSubview(videoCollectionView)
        
        videoCollectionView.addViewWith2(
            left: view.leftAnchor,
            top: view.topAnchor,
            right: view.rightAnchor,
            bottom: view.bottomAnchor,
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
                CenterYConstant: nil
            ),
            multipliers: UIViewMultipliers(
                HeightMultiplier: nil,
                WidthMultiplier: nil
            )
        )
        
        appendNewItem(inViewOfType: .TopViewType,
                      AndItem: CustomUIView.Item(View: view, Ratio: ratio),
                      havingName: name
        )
        
    }
    
    
    
    
}



extension VideoCollectionsView {
    
    enum VideosCollectionView : Int {
        
        case CollectionView = 1
        
    }
    
    func videosCollectionView () -> EmptyUIView {
        
        let viewToBeReturned : EmptyUIView = {
            
            let view = EmptyUIView()
            view.backgroundColor = .clear
            return view
            
        }()
        
        collectionView = GiveMeACollectionView()
        
        var items : Int!
        
        if let delegate = collectionViewsDelegate {
            
            items = delegate.numberOfItems()
            
        }
        
        collectionView.setupCollectionView(
            havingLayout: collectionView.generatelayout(
                havingScrollDirection: .vertical,
                interimSpacing: 0,
                lineSpacing: 0
            ),
            spaceBetweenSections: 10,
            numberOfSections: 1,
            numberOfItemsInSection: [ 1 : collectionViewsDelegate?.numberOfItems() ?? 10 ],
            sizeForCellAtIndexPath: nil,
            orSizeForAllCells: CGSize(width: UIScreen.main.bounds.size.width , height: 80),
            cellsToBeRegisteredInCollectionView: ["VideoCell" : VideoCell.self],
            cellForItemAt: { [weak weakSelf = self] (collectionView, indexPath) -> UICollectionViewCell in
                
                if let delegate = weakSelf?.collectionViewsDelegate {
                    
                    return delegate.collectionViewCellForItemAt(collectionView: collectionView, indexPath: indexPath)
                    
                }else {
                    
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath)
                    return cell
                    
                }
                
                
                
            },
            didSelectItemAt: nil,
            didDeSelectItemAt: nil)
        
        collectionView.setupCollectionViewItems(didSelect: {[weak weakSelf = self] (collectionView, indexPath) in
            
            if let delegate = weakSelf?.collectionViewsDelegate {
                delegate.collectionViewDidSelectCell(collectionView: collectionView, indexPath: indexPath)
            }
            
            
            }, andDidDeSelect: nil)
        
        collectionView.collectionView.backgroundColor = UIColor.init(red: 15 / 255 , green: 16 / 255 , blue: 16 / 255 , alpha: 1)
        
        
        collectionView.tag = VideosCollectionView.CollectionView.rawValue
        
        viewToBeReturned.addSubview(collectionView)
        
        collectionView.addViewWith2(
            left: nil,
            top: nil,
            right: nil,
            bottom: nil,
            height: viewToBeReturned.heightAnchor,
            width: viewToBeReturned.widthAnchor,
            centerX: viewToBeReturned.centerXAnchor,
            centerY: viewToBeReturned.centerYAnchor,
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
                HeightMultiplier: 1,
                WidthMultiplier: 1
            )
        )
        
        
        
        return viewToBeReturned
    }
    
    
    
    
    
}
