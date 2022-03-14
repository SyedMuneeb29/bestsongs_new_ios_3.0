//
//  GiveMeACollectionView.swift
//  Bestsongs_New_Actual
//
//  Created by IMac on 09/01/2019.
//  Copyright © 2019 IMac. All rights reserved.
//

import UIKit

@objc class GiveMeACollectionView : UIView
{
    
 
 
    public var customLayout : UICollectionViewFlowLayout? { didSet {setNeedsLayout()} }
    public var customSpaceBetweenSections : CGFloat = 0
    public var customNumberOfSections : Int?
   
    public typealias SectionNumberInInt = Int
    public typealias NumberOfRowsInInt = Int
    
    public var customNumberOfItemsInSection = [SectionNumberInInt : NumberOfRowsInInt]()
    
    public typealias identifierForCellInString = String
    
    public var customCellsToBeAdded = [identifierForCellInString : AnyClass ]() { didSet {setNeedsLayout()} }
    public var customCellsToBeAdded2 = [identifierForCellInString : Any ]() { didSet {setNeedsLayout()} }
    
    public var customSizeForAllCells : CGSize?  { didSet {setNeedsLayout()} } //{ didSet{  reloadData()  } }
    public var customSizeForCellAtIndexPath : ( ( IndexPath ) -> CGSize )?   //sizeForItemAt indexPath: IndexPath
    
    public var customCellForItemAt : ( ( UICollectionView, IndexPath ) -> UICollectionViewCell )?
    
    public var customDidSelectItemAt : ( ( UICollectionView, IndexPath ) -> Void )?
    public var customDidDeSelectItemAt : ( ( UICollectionView, IndexPath ) -> Void )?
    
    public var closureForDisplayedCell : ( ( UICollectionView , IndexPath , UICollectionViewCell) -> Void)?
    
 
    
    public var didChangeOrientation : Bool  {
        
        get { return false }
        set {
            if newValue == true
            {
                setNeedsLayout() ;
                setNeedsDisplay() ;
                self.collectionView.collectionViewLayout.invalidateLayout()
            }
        }
    }
    
    
    ///////////
    
    private let dummyNoOfRowsInCollectionView : Int = 16
    
    private struct DummyCellIdentifiers {
        static let DummyCellIdentifier = "DummyItem"
    }
    
    
    private let dummylayoutForCollectionView : UICollectionViewFlowLayout = {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        return layout
        
    }()
    
    public lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: dummylayoutForCollectionView)
    
    /////
    
   
    
    
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.setupCollectionViewLayout()
        self.setupCollectionViewCells()
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    
    
    
    
    
    
    
    deinit {
        
        
        
        print ("GiveMeACollectionView is De inititalized")
    }
    
    
    
}

extension GiveMeACollectionView {
    
    // collection View placement :
    
    override func layoutSubviews() {
        
        
        addSubview(collectionView)
        
        collectionView.addViewWith(left: leftAnchor,
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

}


extension GiveMeACollectionView {
    
    // Setup Collection View :
    
    
    private func setupCollectionViewLayout() {
        
        if let layout = customLayout {
            
            collectionView.collectionViewLayout =  layout
            
        }
        else {
            
            collectionView.collectionViewLayout =  dummylayoutForCollectionView
            
        }
    }
    
    
    private func setupCollectionViewCells() {
        
        
        if customCellsToBeAdded.count != 0 {
            
            for (identiferOfCell , cell) in customCellsToBeAdded {
                
                collectionView.register(cell.self, forCellWithReuseIdentifier: identiferOfCell)
                
            }
            
        }else {
            
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: DummyCellIdentifiers.DummyCellIdentifier)
            
        }
        
    }
 
    
    
    
    
    
}



extension GiveMeACollectionView : UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    // Delegates For Collection View :
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        if let numOfSections = customNumberOfSections { return numOfSections }
//        else { return 1 }
//    }
//
    
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let closure = closureForDisplayedCell {
            
            closure(collectionView ,indexPath ,cell)
            
        }
       
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if  customNumberOfItemsInSection.count > 0 {
            
            for (section , numberOfRows ) in customNumberOfItemsInSection {
                
                if section == section {
                    return numberOfRows
                }
                
            }
            
        }
        
        
        return dummyNoOfRowsInCollectionView
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return customSpaceBetweenSections
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if let customSizeForCellAtIndexPath = customSizeForCellAtIndexPath { return customSizeForCellAtIndexPath( indexPath ) }
        
        else if let customSizeForAllCells = customSizeForAllCells { return customSizeForAllCells }
            
        else {
            
            let dummyWidth : CGFloat = 80.0
            let dummyHeight : CGFloat = 80.0
            return CGSize(width: dummyWidth, height: dummyHeight)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let customCellForItemAt = customCellForItemAt { return customCellForItemAt(collectionView,indexPath) }
        
        else {
            
            let dummyCell = collectionView.dequeueReusableCell(withReuseIdentifier: DummyCellIdentifiers.DummyCellIdentifier, for: indexPath)
            dummyCell.backgroundColor = .blue
            return dummyCell
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let customDidSelectItemAt = customDidSelectItemAt { customDidSelectItemAt(collectionView,indexPath) }
        else{
            
            print(" Item Selected At Indexpath : \(indexPath.item)")
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let customDidDeSelectItemAt = customDidDeSelectItemAt { customDidDeSelectItemAt(collectionView,indexPath) }
        else{
            
            print("Item Deselected At Indexpath : \(indexPath.item)")
            
        }
    }
    
    
    
    
}


extension GiveMeACollectionView {
    
    // Utility function for collection view :
    
    public func generatelayout (
        havingScrollDirection scrollDirection : UICollectionView.ScrollDirection ,
                                  interimSpacing : CGFloat ,
                                  lineSpacing : CGFloat
        ) -> UICollectionViewFlowLayout{
            
            let layout = UICollectionViewFlowLayout()
            
            layout.scrollDirection = scrollDirection
            layout.minimumLineSpacing = lineSpacing
            layout.minimumInteritemSpacing = interimSpacing
            
            return layout
        
    }
    
    @objc public func refreshCollectionView () {
        
        self.setupCollectionViewLayout()
        self.setupCollectionViewCells()
        collectionView.reloadData()

    }
    
    public func setupCollectionViewItems (
                                didSelect : ( ( UICollectionView, IndexPath ) -> Void )? ,
                                andDidDeSelect didDeselect: ( ( UICollectionView, IndexPath ) -> Void )?  ) {
        
        if let didSelect = didSelect { customDidSelectItemAt = didSelect }
        if let didDeselect = didDeselect { customDidDeSelectItemAt = didDeselect }
        
        refreshCollectionView()
    }
    
    public func setupCollectionView (
                              havingLayout layout : UICollectionViewFlowLayout ,
                              spaceBetweenSections sectionSpace: CGFloat ,
                              numberOfSections noOfSections : Int ,
                              numberOfItemsInSection : [GiveMeACollectionView.SectionNumberInInt : GiveMeACollectionView.NumberOfRowsInInt] ,
                              sizeForCellAtIndexPath cellSizeAtIndexPath : ((IndexPath) -> CGSize)? ,
                              orSizeForAllCells cellSize : CGSize? ,
                              cellsToBeRegisteredInCollectionView cells : [GiveMeACollectionView.identifierForCellInString : AnyClass] ,
                              cellForItemAt : ((UICollectionView, IndexPath) -> UICollectionViewCell)? ,
                              didSelectItemAt :  ( ( UICollectionView, IndexPath ) -> Void )? ,
                              didDeSelectItemAt :  ( ( UICollectionView, IndexPath ) -> Void )?
                              ) {
        
        
        customLayout = layout
        customSpaceBetweenSections = sectionSpace
        customNumberOfSections = noOfSections
        customNumberOfItemsInSection = numberOfItemsInSection
        if let cellSizeAtIndexPath = cellSizeAtIndexPath { customSizeForCellAtIndexPath = cellSizeAtIndexPath }
        if let cellSize = cellSize { customSizeForAllCells = cellSize }
        customCellsToBeAdded = cells
        customCellForItemAt = cellForItemAt
        if let didSelectItemAt = didSelectItemAt { customDidSelectItemAt = didSelectItemAt }
        if let didDeSelectItemAt = didDeSelectItemAt { customDidDeSelectItemAt = didDeSelectItemAt }
        
        
        refreshCollectionView()
        
        
    }
    
    
}

























