//
//  GiveMeAWebService.swift
//  Bsongs_v1_Muneeb
//
//  Created by Syed Muneeb Ur Rehman on 09/05/2019.
//  Copyright © 2019 Syed Muneeb Ur Rehman. All rights reserved.
//

import Foundation


class GiveMeAWebService : NSObject {
    
    
    let statusCodesDictionary = [ 200 : "STATUS : OK" ,
                                  201 : "STATUS : CREATED" ,
                                  202 : "STATUS : Accepted But Processing is taking ar server side" ,
                                  204 : "STATUS : No Response" ,
                                  400 : "STATUS : Bad request" ,
                                  401 : "STATUS : Unauthorized",
                                  402 : "STATUS : PaymentRequired",
                                  403 : "STATUS : Forbidden",
                                  404 : "STATUS : Not found",
                                  500 : "STATUS : Internal Error",
                                  501 : "STATUS : Not implemented",
                                  502 : "STATUS : Service temporarily overloaded",
                                  503 : "STATUS : Gateway timeout"
    ]
    
    func serviceGET<T:Decodable> ( url : URL , modelsDataType : T ) -> T?{
        
        let webService = GiveMeAWebService()
        var dataToBeReturned : T!
        
        
        
        let semaphore = DispatchSemaphore(value: 0)
        webService.executeWebRequest(withUrl: url, headersValues: nil) { (dataReceived : T? , error) in
            
            if let error = error {
                print("Network Request : Error : \(error)")
            }else if let dataReceived = dataReceived {
                dataToBeReturned = dataReceived
            }
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: .distantFuture)
        
        
        
        return dataToBeReturned
        
    }
    
    
    func serviceGET2<T:Decodable> ( url : URL , modelsDataType : T , headersValue: [String : String]? ) -> T?{
        
        let webService = GiveMeAWebService()
        var dataToBeReturned : T!
        
        
        
        let semaphore = DispatchSemaphore(value: 0)
        webService.executeWebRequest(withUrl: url, headersValues: headersValue) { (dataReceived : T? , error) in
            
            if let error = error {
                print("Network Request : Error : \(error)")
            }else if let dataReceived = dataReceived {
                dataToBeReturned = dataReceived
            }
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: .distantFuture)
        
        return dataToBeReturned
        
    }
    
    func serviceGET2Async<T:Decodable> ( url : URL , modelsDataType : T , headersValue: [String : String]? ,  closure : @escaping (T?) -> () ) -> T?{
        
        let webService = GiveMeAWebService()
        var dataToBeReturned : T!
        
        
        
        
        webService.executeWebRequest(withUrl: url, headersValues: headersValue) { (dataReceived : T? , error) in
            
            if let error = error {
                print("Network Request : Error : \(error)")
            }else if let dataReceived = dataReceived {
                dataToBeReturned = dataReceived
                closure(dataToBeReturned)
            }
            
        }

        
        
        return dataToBeReturned
        
    }
    
    
    
    func executeWebRequest < T : Decodable > (withUrl url : URL ,
                                              headersValues : [String : String]? , completionHandler : @escaping ( T? , Error? ) -> Void ){
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        
        
    
        if let headerValues = headersValues {
            for ( key , value ) in headerValues {
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
        }
        
   
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { [weak weakSelf = self] (data, urlResponse, error) in


            let response = urlResponse as? HTTPURLResponse
            
            guard let statusCode = response?.statusCode else { return }
            
            if let responseStatus = weakSelf?.statusCodesDictionary[statusCode]
            {
                print ("STATUS for url : \(url) is : \(responseStatus) ")
                
            }
            
            if error != nil {
                print ("ERROR : for URL \( url ) : \( error! ) ")
            }else{
                
                do {
                    
                    guard let dataRecv = data else { return }
                    
                    let decoder = JSONDecoder()
                    
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let data = try decoder.decode( T.self, from: dataRecv )
                    
                    completionHandler( data , nil)
                    
                }catch let error {
                    
                    completionHandler( nil , error)
                    print ("ERROR : for URL \(url) : \(error) ")
                }
            }
        }
        
        
        dataTask.resume()
        
        
    }
    
    
    
    
    
    func servicePost<T:Decodable> ( url : URL ,
                                    postBody : [String : String]? ,
                                    headersValues : [String : String]? ,
                                    modelsDataType : T ) -> T? {
        
        let webService = GiveMeAWebService()
        var dataToBeReturned : T!
        
        
        let semaphore = DispatchSemaphore(value: 0)
        webService.executeAPostWebRequest(
            withUrl: url,
            postBody: postBody,
            headersValues: headersValues ) { (dataReceived : T?, error) in
                
                if let error = error {
                    print("Network Request : Error : \(error)")
                }else if let dataReceived = dataReceived {
                    dataToBeReturned = dataReceived
                }
                semaphore.signal()
        }
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        
        return dataToBeReturned
        
        
        
    }
    
    
    
    
    func servicePostAsync<T:Decodable> ( url : URL ,
                                         postBody : [String : String]? ,
                                         headersValues : [String : String]? ,
                                         modelsDataType : T,
                                         closure : @escaping (T?) -> ()
                                         )  {
        
        let webService = GiveMeAWebService()
        var dataToBeReturned : T!
        
        
       
        webService.executeAPostWebRequest(
            withUrl: url,
            postBody: postBody,
            headersValues: headersValues ) { (dataReceived : T?, error) in
                
                if let error = error {
                    
                    print( "Network Request : Error : \(error)" )
                    
                }else if let dataReceived = dataReceived {
                    
                    dataToBeReturned = dataReceived
                    closure( dataToBeReturned )
                    
                }
                
        }
        
 
        
    }
    
    
    
    
    func executeAPostWebRequest < T : Decodable > ( withUrl url : URL ,
                                                    postBody : [String : String]?,
                                                    headersValues : [String : String]?,
                                                    completionHandler : @escaping ( T? , Error? ) -> Void ){
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "POST"
        
        if let body = postBody {
            guard let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else { return }
            urlRequest.httpBody = httpBody
        }
        
        if let headerValues = headersValues {
            for ( key , value ) in headerValues {
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        
        
        
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { [weak weakSelf = self] (data, urlResponse, error) in
            
            let response = urlResponse as? HTTPURLResponse
            guard let statusCode = response?.statusCode else { return }
            
            if let responseStatus = weakSelf?.statusCodesDictionary[statusCode]
            {
                print ("STATUS for url : \(url) is : \(responseStatus) ")
            }
            
            if error != nil {
                print ("ERROR : for URL \( url ) : \( error! ) ")
            }else{
                
                do {
                    
                    guard let dataRecv = data else { return }
                    
                    let decoder = JSONDecoder()
                    
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let data = try decoder.decode( T.self, from: dataRecv )
                    
                    completionHandler( data , nil)
                    
                }catch let error {
                    print ("ERROR : for URL \(url) : \(error) ")
                }
            }
        }
        
        
        dataTask.resume()
        
        
    }
    
}
