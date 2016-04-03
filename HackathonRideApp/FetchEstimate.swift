//
//  FetchEstimate.swift
//  HackathonRideApp
//
//  Created by Vrezh Gulyan on 4/2/16.
//  Copyright © 2016 Chris Repanich. All rights reserved.
//

import Foundation

struct FetchEstimate{

    func getEstimate(start_address: String, end_address: String, completion: (PriceEstimate? -> Void)) {
        
        var startLat, startLong : Float
        (startLat,startLong) = LocationHelper.getLatLongFromAddress(start_address)
        var endLat, endLong : Float
        (endLat,endLong) = LocationHelper.getLatLongFromAddress(end_address)
        
        if let url = NSURL(string: "https://api.uber.com/v1/estimates/price?start_latitude=\(startLat)&server_token=xHire5cK16V9eQgU_MhA-y6vs2OZqHKLTtk0YiBF&start_longitude=\(startLong)&end_latitude=\(endLat)&end_longitude=\(endLong)"){
            let networkOperation = NetworkOperation(url: url)
    
            networkOperation.downloadJSONFromURl{
                (let JSONDictionary) in
                let estimate = PriceEstimate(estimateDictionary: JSONDictionary)
                    completion(estimate)
        
            }
    
            } else {
            
            print("Could not construct a valid URL")
        }
    }
    
    func getTimeEstimate(start_address: String, completion: (TimeEstimate? -> Void)){
        
        var startLat, startLong : Float
        (startLat,startLong) = LocationHelper.getLatLongFromAddress(start_address)
        
        if let url = NSURL(string: "https://api.uber.com/v1/estimates/time?start_latitude=\(startLat)&server_token=xHire5cK16V9eQgU_MhA-y6vs2OZqHKLTtk0YiBF&start_longitude=\(startLong)"){
            let networkOperation = NetworkOperation(url: url)
            
            networkOperation.downloadJSONFromURl{
                (let JSONDictionary) in
                let time = TimeEstimate(timesDictionary: JSONDictionary)
                completion(time)
                
            }
            
        } else {
            
            print("Could not construct a valid URL")
        }
    }
}