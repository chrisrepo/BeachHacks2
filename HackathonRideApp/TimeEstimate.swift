//
//  TimeEstimate.swift
//  HackathonRideApp
//
//  Created by Vrezh Gulyan on 4/3/16.
//  Copyright © 2016 Chris Repanich. All rights reserved.
//

import Foundation

struct TimeEstimate {
    
    var vehicleType: String?
    var eta: Int?
    
    
    init(timesDictionary: [String:AnyObject]?){
        if let times = timesDictionary?["times"]
        {
            if let time : [String: AnyObject] = times[0] as? [String: AnyObject]{
                vehicleType = time["display_name"] as? String
                eta = time["estimate"] as? Int
                
            }
        }
    }
}