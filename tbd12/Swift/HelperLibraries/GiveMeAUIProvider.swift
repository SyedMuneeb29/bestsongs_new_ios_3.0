//
//  GiveMeAUIProvider.swift
//  Takkuu
//
//  Created by Syed Muneeb ur Rehman on 1/2/19.
//  Copyright © 2019 EwicanTech. All rights reserved.
//  Legal action will be taken against copy right infiringement

import UIKit
import Foundation


class GiveMeAUIProvider : NSObject {
    
    // UILabel //
    
    struct SettingsForUILabel {
        var Text : String?
        var Font : UIFont?
        var TextColor : UIColor?
        var ShadowColor : UIColor?
        var ShadowOffset : CGSize?
        var TextAlignment : NSTextAlignment?
        var LineBreakMode : NSLineBreakMode?
        var HighlightedTextColor : UIColor?
        var IsHighlighted : Bool?
        var NumberOfLines : Int?
        var AdjustedFontSizeToFitWidth : Bool?
        
        
        init(text : String? ,
             font : UIFont? ,
             textColor : UIColor? ,
             shadowColor : UIColor? ,
             shadowOffset : CGSize? ,
             textAlignment : NSTextAlignment? ,
             lineBreakMode : NSLineBreakMode? ,
             highlightedTextColor : UIColor? ,
             isHighlighted : Bool? ,
             numberOfLines : Int? ,
             adjustFontSizeToWidth : Bool?
            ) {
            self.Text = text
            self.Font = font
            self.TextColor = textColor
            self.ShadowColor = shadowColor
            self.ShadowOffset = shadowOffset
            self.TextAlignment = textAlignment
            self.LineBreakMode = lineBreakMode
            self.HighlightedTextColor = highlightedTextColor
            self.IsHighlighted = isHighlighted
            self.NumberOfLines = numberOfLines
            self.AdjustedFontSizeToFitWidth = adjustFontSizeToWidth
            
        }
        
    }
    
    
    
    
    func customUILabel ( withSetting settings : SettingsForUILabel ) -> UILabel{
        
        let label = UILabel()
        
        label.text = settings.Text ?? "UI - Label"
        label.textColor = settings.TextColor ?? UIColor.black
        label.font = settings.Font ?? UIFont(name: "Chalkduster", size: 17.0)
        label.shadowColor = settings.ShadowColor ?? UIColor.clear
        label.shadowOffset = settings.ShadowOffset ?? CGSize(width: 0, height: 0)
        label.textAlignment = settings.TextAlignment ?? NSTextAlignment.left
        label.lineBreakMode = settings.LineBreakMode ?? NSLineBreakMode.byWordWrapping
        label.highlightedTextColor = settings.HighlightedTextColor ?? UIColor.gray
        label.isHighlighted = settings.IsHighlighted ?? false
        label.numberOfLines = settings.NumberOfLines ?? 1
        label.adjustsFontSizeToFitWidth = settings.AdjustedFontSizeToFitWidth ?? false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
        return label
    }
    
    // UIButton //
    
    
    struct SettingsForUIButton{
        
        
    
        
        var buttonType : UIButton.ButtonType?
        var setTitle : (title : String , state : UIControl.State)?
        var setTitleColor : (color : UIColor , state : UIControl.State)?
        var setTitleShadowColor : (color : UIColor , state : UIControl.State)?
        var setImage : (image : UIImage , state : UIControl.State)?
        var setBackgroundImage : (image : UIImage , state : UIControl.State )?
        var setAttributedTitle : (title : NSAttributedString , state : UIControl.State)?
        var tintColor : UIColor?
        var showsTouchWhenHighlighted : Bool?
        var adjustImageWhenHighlighted : Bool?
        var adjustImageWhenDisabled : Bool?
        var imageEdgeInsets : UIEdgeInsets?
        var reversesTitleShadowWhenHighlighted : Bool?
        var titleEdgeInsets : UIEdgeInsets?
        var contentEdgeInsets : UIEdgeInsets?
        
        init(buttonType : UIButton.ButtonType? ,
             setTitle : (title : String , state : UIControl.State)? ,
             setTitleColor : (color : UIColor , state : UIControl.State)? ,
             setTitleShadowColor : (color : UIColor , state : UIControl.State)? ,
             setImage : (image : UIImage , state : UIControl.State)? ,
             setBackgroundImage : (image : UIImage , state : UIControl.State )? ,
             setAttributedTitle : (title : NSAttributedString , state : UIControl.State)? ,
             tintColor : UIColor? ,
             showsTouchWhenHighlighted : Bool? ,
             adjustImageWhenHighlighted : Bool? ,
             adjustImageWhenDisabled : Bool? ,
             imageEdgeInsets : UIEdgeInsets? ,
             reversesTitleShadowWhenHighlighted : Bool? ,
             titleEdgeInsets : UIEdgeInsets? ,
             contentEdgeInsets : UIEdgeInsets?) {
            
            self.buttonType = buttonType
            self.setTitle = setTitle
            self.setTitleColor = setTitleColor
            self.setTitleShadowColor = setTitleShadowColor
            self.setImage = setImage
            self.setBackgroundImage = setBackgroundImage
            self.setAttributedTitle = setAttributedTitle
            self.tintColor = tintColor
            self.showsTouchWhenHighlighted = showsTouchWhenHighlighted
            self.adjustImageWhenHighlighted = adjustImageWhenHighlighted
            self.adjustImageWhenDisabled = adjustImageWhenDisabled
            self.imageEdgeInsets = imageEdgeInsets
            self.reversesTitleShadowWhenHighlighted = reversesTitleShadowWhenHighlighted
            self.titleEdgeInsets = titleEdgeInsets
            self.contentEdgeInsets = contentEdgeInsets
            
            
        }
        
        
    }
    func customUIButton ( withSetting settings : SettingsForUIButton ) -> UIButton{
        
        let button = UIButton(type: settings.buttonType ?? .system)
        
        button.setTitle(
            settings.setTitle?.title ?? "",
            for: settings.setTitle?.state ?? UIControl.State.normal
        )
        button.setTitleColor(
            settings.setTitleColor?.color ?? UIColor.black ,
            for: settings.setTitleColor?.state ?? UIControl.State.normal
        )
        button.setTitleShadowColor(
            settings.setTitleShadowColor?.color ?? UIColor.clear ,
            for: settings.setTitleShadowColor?.state ?? UIControl.State.normal
        )
        button.setImage(
            settings.setImage?.image ?? nil ,
            for: settings.setImage?.state ?? UIControl.State.normal
        )
        button.setBackgroundImage(
            settings.setBackgroundImage?.image ?? nil ,
            for: settings.setBackgroundImage?.state ?? UIControl.State.normal
        )
        button.setAttributedTitle(
            settings.setAttributedTitle?.title ?? nil ,
            for: settings.setAttributedTitle?.state ?? UIControl.State.normal
        )
        
        button.tintColor = settings.tintColor ?? UIColor.clear
        button.showsTouchWhenHighlighted = settings.showsTouchWhenHighlighted ?? false
        button.adjustsImageWhenHighlighted = settings.adjustImageWhenHighlighted ?? true
        button.adjustsImageWhenDisabled = settings.adjustImageWhenDisabled ?? true
        button.imageEdgeInsets = settings.imageEdgeInsets ?? UIEdgeInsets.zero
        button.reversesTitleShadowWhenHighlighted = settings.reversesTitleShadowWhenHighlighted ?? false
        button.titleEdgeInsets = settings.titleEdgeInsets ?? UIEdgeInsets.zero
        button.contentEdgeInsets = settings.contentEdgeInsets ?? UIEdgeInsets.zero
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        return button
    }
    
    
    // UIImageView //
    
    typealias UseThisFunctionToStartAnimationWhenYouWant = Bool
    typealias UseThisFunctionToStopAnimationWhenYouWant = Bool
    struct SettingsForUIImageView {
        
        var image : UIImage?
        var isUserInteractionEnabled : Bool?
        var isHighlighted : Bool?
        var highlightedImage : UIImage?
        var animationImages : [UIImage]?
        var highlightedAnimationImages : [UIImage]?
        var animationDuration : TimeInterval?
        var animationRepeatCount : Int? // zero means infinite times
        var startAnimating : UseThisFunctionToStartAnimationWhenYouWant?
        var stopAnimating : UseThisFunctionToStopAnimationWhenYouWant?
        var tintColor : UIColor?
        var contentMode : UIView.ContentMode?
        
        init(  image : UIImage? ,
               isUserInteractionEnabled : Bool? ,
               isHighlighted : Bool? ,
               highlightedImage : UIImage? ,
               animationImages : [UIImage]? ,
               highlightedAnimationImages : [UIImage]? ,
               animationDuration : TimeInterval? ,
               animationRepeatCount : Int? , // zero means infinite times
            startAnimating : UseThisFunctionToStartAnimationWhenYouWant? ,
            stopAnimating : UseThisFunctionToStopAnimationWhenYouWant? ,
            tintColor : UIColor? ,
               contentMode : UIView.ContentMode?
            ){
            
            self.image = image
            self.isUserInteractionEnabled = isUserInteractionEnabled
            self.isHighlighted = isHighlighted
            self.highlightedImage = highlightedImage
            self.animationImages = animationImages
            self.highlightedAnimationImages = highlightedAnimationImages
            self.animationDuration = animationDuration
            self.animationRepeatCount =  animationRepeatCount// zero means infinite times
            self.startAnimating = startAnimating
            self.stopAnimating = stopAnimating
            self.tintColor = tintColor
            self.contentMode = contentMode
            
        }
        
        
    }
    func customImageView ( withSetting settings : SettingsForUIImageView ) -> CustomUIImageView{
        
        let imageView = CustomUIImageView()
        
        imageView.image = settings.image ?? nil
        imageView.isUserInteractionEnabled = settings.isUserInteractionEnabled ?? false
        imageView.isHighlighted = settings.isHighlighted ?? false
        imageView.highlightedImage = settings.highlightedImage ?? nil
        imageView.animationImages = settings.animationImages ?? nil
        imageView.highlightedAnimationImages = settings.highlightedAnimationImages ?? nil
        imageView.animationDuration = settings.animationDuration ?? 1
        imageView.animationRepeatCount = settings.animationRepeatCount ?? 0
        if let tintColor = settings.tintColor { imageView.tintColor = tintColor }
        if let contentMode = settings.contentMode { imageView.contentMode = contentMode }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        return imageView
    }
    
    // UITextField//
    
    
    
    
    struct SettingsForTextField {
        
        
        
        var text : String?
        var textColor : UIColor?
        var font : UIFont?
        var textAlignment : NSTextAlignment?
        var borderStyle : UITextField.BorderStyle?
        var attributedText : NSAttributedString?
        //   var defaultTextAttributes: [NSAttributedString.Key : Any]?
        var placeholder : String?
        var attributedPlaceholder : NSAttributedString?
        var clearsOnBeginEditing : Bool?
        var adjustFontSizeToFitWidth : Bool?
        var minimumFontSize : CGFloat?
        var delegate : UITextFieldDelegate?
        var background : UIImage?
        var disabledBackground : UIImage?
        var allowsEditingTextAttributes : Bool?
        //     var typingAttributes : [NSAttributedString.Key : Any]?
        /////////
        var clearButtonMode : UITextField.ViewMode?
        var leftView : UIView?
        var leftViewMode : UITextField.ViewMode?
        var rightView : UIView?
        var rightViewMode : UITextField.ViewMode?
        ////////
        var borderRect : CGRect?
        var textRect : CGRect?
        var placeHolderRect : CGRect?
        var editingRect : CGRect?
        var clearButtonRect : CGRect?
        var leftViewRect : CGRect?
        var rightViewRect : CGRect?
        var drawTextInRect : CGRect?
        var drawPlaceholderInRect : CGRect?
        var inputView : UIView?
        var inputAccessoryView : UIView?
        var clearsOnInsertions : Bool?
        
        
        init ( text : String? ,
               textColor : UIColor? ,
               font : UIFont? ,
               textAlignment : NSTextAlignment? ,
               borderStyle : UITextField.BorderStyle? ,
               attributedText : NSAttributedString? ,
               //   var defaultTextAttributes: [NSAttributedString.Key : Any]?
            placeholder : String? ,
            attributedPlaceholder : NSAttributedString? ,
            clearsOnBeginEditing : Bool? ,
            adjustFontSizeToFitWidth : Bool? ,
            minimumFontSize : CGFloat? ,
            delegate : UITextFieldDelegate? ,
            background : UIImage? ,
            disabledBackground : UIImage? ,
            allowsEditingTextAttributes : Bool? ,
            //     var typingAttributes : [NSAttributedString.Key : Any]?
            /////////
               clearButtonMode : UITextField.ViewMode? ,
            leftView : UIView? ,
               leftViewMode : UITextField.ViewMode? ,
            rightView : UIView? ,
               rightViewMode : UITextField.ViewMode? ,
            ////////
            borderRect : CGRect? ,
            textRect : CGRect? ,
            placeHolderRect : CGRect? ,
            editingRect : CGRect? ,
            clearButtonRect : CGRect? ,
            leftViewRect : CGRect? ,
            rightViewRect : CGRect? ,
            drawTextInRect : CGRect? ,
            drawPlaceholderInRect : CGRect? ,
            inputView : UIView? ,
            inputAccessoryView : UIView? ,
            clearsOnInsertions : Bool?
            ) {
            self.text = text
            self.textColor = textColor
            self.font = font
            self.textAlignment = textAlignment
            self.borderStyle = borderStyle
            self.attributedText = attributedText
            //   var defaultTextAttributes: [NSAttributedString.Key : Any]?
            self.placeholder = placeholder
            self.attributedPlaceholder = attributedPlaceholder
            self.clearsOnBeginEditing = clearsOnBeginEditing
            self.adjustFontSizeToFitWidth = adjustFontSizeToFitWidth
            self.minimumFontSize = minimumFontSize
            self.delegate = delegate
            self.background = background
            self.disabledBackground = disabledBackground
            self.allowsEditingTextAttributes = allowsEditingTextAttributes
            //     var typingAttributes : [NSAttributedString.Key : Any]?
            /////////
            self.clearButtonMode = clearButtonMode
            self.leftView = leftView
            self.leftViewMode = leftViewMode
            self.rightView = rightView
            self.rightViewMode = rightViewMode
            ////////
            self.borderRect = borderRect
            self.textRect = textRect
            self.placeHolderRect = placeHolderRect
            self.editingRect = editingRect
            self.clearButtonRect = clearButtonRect
            self.leftViewRect = leftViewRect
            self.rightViewRect = rightViewRect
            self.drawTextInRect = drawTextInRect
            self.drawPlaceholderInRect = drawPlaceholderInRect
            self.inputView = inputView
            self.inputAccessoryView = inputAccessoryView
            self.clearsOnInsertions = clearsOnInsertions
            
        }
        
        
        
    }
    func customTextField ( withSetting settings : SettingsForTextField ) -> UITextField {
        
        let textfield = UITextField()
        
        textfield.text = settings.text ?? nil
        textfield.textColor = settings.textColor ?? nil
        textfield.font = settings.font ?? nil
        textfield.textAlignment = settings.textAlignment ?? NSTextAlignment.left
        textfield.borderStyle = settings.borderStyle ?? UITextField.BorderStyle.none
        textfield.attributedText = settings.attributedText ?? nil
        //      textfield.defaultTextAttributes = settings.defaultTextAttributes
        textfield.placeholder = settings.placeholder ?? "Type text here"
        textfield.attributedPlaceholder = settings.attributedPlaceholder ?? nil
        textfield.clearsOnBeginEditing = settings.clearsOnBeginEditing ?? false
        textfield.adjustsFontSizeToFitWidth = settings.adjustFontSizeToFitWidth ?? false
        textfield.minimumFontSize = settings.minimumFontSize ?? 4.0
        textfield.delegate = settings.delegate ?? nil
        textfield.background = settings.background ?? nil
        textfield.disabledBackground = settings.disabledBackground ?? nil
        textfield.allowsEditingTextAttributes = settings.allowsEditingTextAttributes ?? false
        //     textfield.typingAttributes = settings.typingAttributes ?? nil
        textfield.clearButtonMode = settings.clearButtonMode ?? UITextField.ViewMode.never
        textfield.leftView = settings.leftView ?? nil
        textfield.leftViewMode = settings.leftViewMode ?? UITextField.ViewMode.never
        textfield.rightView = settings.rightView ?? nil
        textfield.rightViewMode = settings.rightViewMode ?? UITextField.ViewMode.never
        
        if let borderRect = settings.borderRect { textfield.borderRect(forBounds: borderRect ) }
        if let textRect = settings.textRect { textfield.textRect(forBounds: textRect ) }
        if let placeHolderRect = settings.placeHolderRect { textfield.placeholderRect(forBounds: placeHolderRect ) }
        if let editingRect = settings.editingRect { textfield.editingRect(forBounds: editingRect ) }
        if let clearButtonRect = settings.clearButtonRect { textfield.clearButtonRect(forBounds: clearButtonRect ) }
        if let leftViewRect = settings.leftViewRect { textfield.leftViewRect(forBounds: leftViewRect ) }
        if let rightViewRect = settings.rightViewRect { textfield.rightViewRect(forBounds: rightViewRect ) }
        if let drawTextInRect = settings.drawTextInRect { textfield.drawText(in: drawTextInRect) }
        if let drawPlaceholderInRect = settings.drawPlaceholderInRect { textfield.drawPlaceholder(in: drawPlaceholderInRect) }
        
        textfield.inputView = settings.inputView ?? nil
        textfield.inputAccessoryView = settings.inputAccessoryView ?? nil
        textfield.clearsOnInsertion = settings.clearsOnInsertions ?? false
        textfield.translatesAutoresizingMaskIntoConstraints = false
        
        return textfield
    }
    
    
    
    
    
}
