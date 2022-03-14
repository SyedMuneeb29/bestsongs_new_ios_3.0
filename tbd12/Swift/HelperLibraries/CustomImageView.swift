//
//  CustomImageView.swift
//  Bestsongs_New_Actual
//
//  Created by IMac on 13/02/2019.
//  Copyright © 2019 IMac. All rights reserved.
//

import UIKit


var cacheForImages = NSCache<AnyObject , AnyObject>()

class CustomUIImageView : UIImageView {
    
    var urlForImage : URL?
    var statusCodeOfImage : Int?
    
    
    func loadImageWith ( url : URL ) {
        
        
        DispatchQueue.main.async { [weak weakSelf = self] in
            weakSelf?.urlForImage = url
        }
        
        if let imageForUrl_FromCache = cacheForImages.object(forKey: url as AnyObject ) as? UIImage {
            
            DispatchQueue.main.async { [weak weakSelf = self] in
                weakSelf?.image = imageForUrl_FromCache
            }
            
            
        }else {
            
            
            let task = URLSession.shared.dataTask( with: url ) { [weak weakSelf = self] ( data , response , error) in
                
                let httpResponse = response as? HTTPURLResponse
                
                if let statusCode = httpResponse?.statusCode {
                    weakSelf?.statusCodeOfImage = statusCode
                    print(" CustomUIImageView - loadImageWithURl - Status Code : \(statusCode) ")
                }
                
                if let error = error {
                    
                    print(" CustomUIImageView - loadImageWithURl - Error : \(error) ")
                    return
                }
                
                if let data = data {
                    
                    let imageForUrl_FromNetwork = UIImage(data: data)!
                    
                    if weakSelf?.urlForImage == url {
                        
                        DispatchQueue.main.async {
                            weakSelf?.image = imageForUrl_FromNetwork
                            print("11111")
                        }
                        
                    }else {
                        
                        
                        if let imageForUrl_FromCache = cacheForImages.object(forKey: weakSelf?.urlForImage as AnyObject ) as? UIImage {
                            
                            DispatchQueue.main.async { [weak weakSelf = self] in
                                weakSelf?.image = imageForUrl_FromCache
                            }
                            
                            print("22222")
                            
                        }
                        
                        
                        
                    }
                    cacheForImages.setObject( imageForUrl_FromNetwork , forKey: url as AnyObject )
                    
                    
                }
                
            }
            
            task.resume()
            
            
            
        }
        
    }
    
    
}
