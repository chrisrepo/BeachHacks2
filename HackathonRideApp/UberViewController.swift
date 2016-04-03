//
//  UberViewController.swift
//  HackathonRideApp
//
//  Created by Chris on 4/2/16.
//  Copyright © 2016 Chris Repanich. All rights reserved.
//

import Foundation
import UIKit
import UberRides

class UberViewController : UIViewController {
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var estimateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var etaLabel: UILabel!
    @IBOutlet weak var lyftTypeLabel: UILabel!
    @IBOutlet weak var lyftCostLabel: UILabel!
    @IBOutlet weak var lyftETALabel: UILabel!
    @IBOutlet weak var lyftDurationLabel: UILabel!
    @IBOutlet weak var startAddressField: UITextField!
    @IBOutlet weak var endAddressField: UITextField!
    @IBOutlet weak var requestButton: RequestButton!
    
    typealias JSONDictionaryCompletion = ([ String: AnyObject]?) -> Void
    
    var start_lat:Float = FLT_MAX
    var start_lon:Float = FLT_MAX
    var end_lat:Float = FLT_MAX
    var end_lon:Float = FLT_MAX
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Extra Comment
        
        startAddressField.text = "6000 Fulton Ave, Van Nuys, Ca"
        endAddressField.text = "1250 Bellflower Blvd, Long Beach"
        
//        let button = RequestButton()
//        view.addSubview(button)
        

        
        
    }
    @IBAction func onEstimateClicked(sender: AnyObject) {
        
        (start_lat, start_lon) = LocationHelper.getLatLongFromAddress(startAddressField.text!)
        (end_lat, end_lon) = LocationHelper.getLatLongFromAddress(endAddressField.text!)
        
        let start_address = startAddressField.text!
        let end_address = endAddressField.text!
        
        if (start_address == "" || end_address == "") {
            
        } else {
            
            let estimateInfo = FetchEstimate()
            estimateInfo.getEstimate(start_address,end_address: end_address) {
                (let estimate) in
                if let estimateDetails = estimate{
                    
                    dispatch_async(dispatch_get_main_queue()){
                        if let type = estimateDetails.vehicleType {
                            self.typeLabel?.text = type
                        }
                        if let estimate = estimateDetails.range {
                            self.estimateLabel?.text = estimate
                        }
                        if let duration = estimateDetails.duration {
                            let time = (duration/60)
                            var type = ""
                            if (time < 2){
                                type = "minute"
                            } else {
                                type = "minutes"
                            }
                            self.durationLabel?.text = ("\(time) \(type)")
                        }
                        
                        
                    }
                    
                }
            }
            
            estimateInfo.getTimeEstimate(start_address) {
                (let time) in
                if let timeDetails = time{
                    dispatch_async(dispatch_get_main_queue()){
                        if let eta = timeDetails.eta {
                            let time = (eta/60)
                            var type = ""
                            
                            if (time < 2){
                                type = "minute"
                            } else {
                                type = "minutes"
                            }
                            self.etaLabel?.text = ("\(time) \(type)")
                        }
                    }
                }
            }
            

            estimateButtonPressed()
            
        }
    }
    
     func estimateButtonPressed() {
        
        let start_address = startAddressField.text!
        let end_address = endAddressField.text!
        if (start_address == "" || end_address == "") {
            
        } else {
            var estimatesETA = LyftHelper.getTimeEstimate(start_address)
            if let error = estimatesETA[0]["error"] {
                //if there's an error message, we figure it out
                //else, leggoooooo
            } else {
                //update labels with estimates
                let firstETA = estimatesETA[0] as [String: AnyObject]
                let secVal = firstETA["eta_seconds"] as! Int
                let minVal = secVal/60
                
                dispatch_async(dispatch_get_main_queue()){
                if (minVal < 2) {
                    self.lyftETALabel.text = "1 minute"
                } else {
                    self.lyftETALabel.text = "\(minVal) minutes"
                }
                }
            }
            var estimatesCOST = LyftHelper.getCostEstimate(start_address, end_address: end_address)
            if let error = estimatesCOST[0]["error"] {
                //if there's an error message, we figure it out
                //else, leggoooooo
            } else {
                //update labels with estimates
                let firstCost = estimatesCOST[0] as [String: AnyObject]
                var type = firstCost["ride_type"] as? String
                if (type == "lyft_line"){
                    type = "Lyft line"
                }
                
                var lyftDuration = firstCost["estimated_duration_seconds"] as? Int
                
                lyftDuration! /= 60
                

                
                
                let costMax = firstCost["estimated_cost_cents_max"] as! Double
                let maxDollar = costMax/100
                let max = Int(round(100*maxDollar)/100)
                let costMin = firstCost["estimated_cost_cents_min"] as! Double
                let minDollar = costMin/100
                let min = Int(round(100*minDollar)/100)
                
                dispatch_async(dispatch_get_main_queue()){
                if (lyftDuration < 2){
                    self.lyftDurationLabel.text = "1 minute"
                } else {
                    self.lyftDurationLabel.text = "\(lyftDuration!) minutes"
                }
                
                self.lyftTypeLabel.text = "\(type!)"
                    if(min == max){
                        self.lyftCostLabel.text = "$\(min)"
                    } else {
                        self.lyftCostLabel.text = "$\(min)-$\(max)"
                    }
                
                    self.requestButton.setPickupLocation(latitude: Double(self.start_lat), longitude: Double(self.start_lon))
                    self.requestButton.setDropoffLocation(latitude: Double(self.end_lat), longitude: Double(self.end_lon))
                    
                }
                
            }
            
        }
    }
    

    @IBAction func requestLyftButtonPressed(sender: AnyObject) {
        let myApp = UIApplication.sharedApplication()
        let lyftAppURL = NSURL(string: "lyft://ridetype?id=lyft&pickup[latitude]=\(start_lat)&pickup[longitude]=\(start_lon)&destination[latitude]=\(end_lat)&destination[longitude]=\(end_lon)")!
        if myApp.canOpenURL(lyftAppURL) {
            // Lyft is installed; launch it
            myApp.openURL(lyftAppURL)
        } else {
            // Lyft not installed; open App Store
            let lyftAppStoreURL = NSURL(string: "https://itunes.apple.com/us/app/lyft-taxi-bus-app-alternative/id529379082?mt=8")!
            myApp.openURL(lyftAppStoreURL)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}