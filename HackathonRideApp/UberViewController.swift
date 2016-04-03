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
    @IBOutlet weak var startAddressField: UITextField!
    @IBOutlet weak var endAddressField: UITextField!
    
    typealias JSONDictionaryCompletion = ([ String: AnyObject]?) -> Void
    
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
        
        let start_address = startAddressField.text!
        let end_address = endAddressField.text!
        if (start_address == "" || end_address == "") {
            
        } else {
            
            let estimateInfo = FetchEstimate();
            estimateInfo.getEstimate {
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
            
            var estimatesETA = LyftHelper.getTimeEstimate(start_address)
            if let error = estimatesETA[0]["error"] {
                //if there's an error message, we figure it out
                //else, leggoooooo
            } else {
                //update labels with estimates
                let firstETA = estimatesETA[0] as [String: AnyObject]
                let secVal = firstETA["eta_seconds"] as! Int
                let minVal = secVal/60
                if (minVal < 2) {
                    etaLabel.text = "1 minute"
                } else {
                    etaLabel.text = "\(minVal) minutes"
                }
            }

            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}