//
//  extensionHelper.swift
//  Takkuu
//
//  Created by Suunnoo Team on 1/2/19.
//  Copyright © 2019 EwicanTech. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    
    
    
    func addViewWith( left : NSLayoutXAxisAnchor? , top : NSLayoutYAxisAnchor? , right : NSLayoutXAxisAnchor? , bottom : NSLayoutYAxisAnchor? , height : CGFloat? , width : CGFloat? , centerX : NSLayoutXAxisAnchor? , centerY :NSLayoutYAxisAnchor? , constants : UIViewConstants ){
        
        
        if let leftPosition = left { self.leftAnchor.constraint(equalTo: leftPosition, constant: constants.LeftConstant ?? 0 ).isActive = true }
        if let topPosition = top { self.topAnchor.constraint(equalTo: topPosition, constant: constants.TopConstant ?? 0).isActive = true }
        if let rightPosition = right { self.rightAnchor.constraint(equalTo: rightPosition, constant: constants.RightConstant ?? 0).isActive = true }
        if let bottomPosition = bottom { self.bottomAnchor.constraint(equalTo: bottomPosition, constant: constants.BottomConstant ?? 0).isActive = true }
        if let heightValue = height { self.heightAnchor.constraint(equalToConstant: heightValue - (constants.HeightConstant ?? 0) ).isActive = true }
        if let widthValue = width {  self.widthAnchor.constraint(equalToConstant: widthValue - (constants.WidthConstant ?? 0) ).isActive = true }
        if let centerXPosition = centerX { self.centerXAnchor.constraint(equalTo: centerXPosition, constant: constants.CenterXConstant ?? 0).isActive = true }
        if let centerYPosition = centerY { self.centerYAnchor.constraint(equalTo: centerYPosition, constant: constants.CenterYConstant ?? 0).isActive = true }
        
        
    }
    
    func addViewWith2( left : NSLayoutXAxisAnchor? , top : NSLayoutYAxisAnchor? , right : NSLayoutXAxisAnchor? , bottom : NSLayoutYAxisAnchor? , height : NSLayoutDimension? , width : NSLayoutDimension? , centerX : NSLayoutXAxisAnchor? , centerY :NSLayoutYAxisAnchor? , constants : UIViewConstants ,
                       multipliers : UIViewMultipliers ){
        
        
        if let leftPosition = left { self.leftAnchor.constraint(equalTo: leftPosition, constant: constants.LeftConstant ?? 0 ).isActive = true }
        if let topPosition = top { self.topAnchor.constraint(equalTo: topPosition, constant: constants.TopConstant ?? 0).isActive = true }
        if let rightPosition = right { self.rightAnchor.constraint(equalTo: rightPosition, constant: constants.RightConstant ?? 0).isActive = true }
        if let bottomPosition = bottom { self.bottomAnchor.constraint(equalTo: bottomPosition, constant: constants.BottomConstant ?? 0).isActive = true }
        if let heightValue = height { self.heightAnchor.constraint(equalTo: heightValue, multiplier: multipliers.HeightMultiplier ?? 1, constant: constants.WidthConstant ?? 0).isActive = true }
        if let widthValue = width {  self.widthAnchor.constraint(equalTo: widthValue, multiplier: multipliers.WidthMultiplier ?? 1, constant: constants.WidthConstant ?? 0).isActive = true }
        if let centerXPosition = centerX { self.centerXAnchor.constraint(equalTo: centerXPosition, constant: constants.CenterXConstant ?? 0).isActive = true }
        if let centerYPosition = centerY { self.centerYAnchor.constraint(equalTo: centerYPosition, constant: constants.CenterYConstant ?? 0).isActive = true }
//        constraint(equalToConstant: widthValue - (constants.WidthConstant ?? 0) )
        
    }

    
    
    
}



extension UIImage {
    func image(withTintColor color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(.normal)
        
        let rect = CGRect(origin: .zero, size: size)
        context?.clip(to: rect, mask: cgImage!)
        color.setFill()
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}

struct UIViewConstants {
    
    var LeftConstant : CGFloat?
    var TopConstant : CGFloat?
    var RightConstant : CGFloat?
    var BottomConstant : CGFloat?
    var HeightConstant : CGFloat?
    var WidthConstant : CGFloat?
    var CenterXConstant : CGFloat?
    var CenterYConstant : CGFloat?
    
}

struct UIViewMultipliers {
    
    
    var HeightMultiplier : CGFloat?
    var WidthMultiplier : CGFloat?
    
    
}


class EmptyUIView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
