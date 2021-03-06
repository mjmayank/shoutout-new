//
//  SOPinBusinessViewController.swift
//  shoutout
//
//  Created by Mayank Jain on 1/7/16.
//  Copyright © 2016 Mayank Jain. All rights reserved.
//

import UIKit

class SOPinBusinessViewController: UIViewController {

    @IBOutlet var capacityLabel: UILabel!
    @IBOutlet var capacityBackgroundView: UIView!
    @IBOutlet var graphView: UIView!
    @IBOutlet var headerBackgroundView: UIView!
    @IBOutlet var rightModuleLabel: UILabel!
    @IBOutlet var safariButton: UIButton!
    
    var annotation : SOAnnotation!
    var latitude : NSNumber!
    var longitude : NSNumber!
    var pieChart : PNFilledPieChart!
    let blueColor = UIColor(red: 122.0/255.0, green: 224.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    let pinkColor = UIColor(red: 239.0/255.0, green: 168.0/255.0, blue: 232.0 / 255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.headerBackgroundView.layer.cornerRadius = 20.0;
        self.headerBackgroundView.clipsToBounds = true;
        
        self.capacityBackgroundView.layer.borderColor = UIColor.blackColor().CGColor;
//            UIColor(red: 147/255.0, green: 149 / 255.0, blue: 152 / 255.0, alpha: 1.0).CGColor;
        self.capacityBackgroundView.layer.borderWidth = 2.0;
        self.capacityBackgroundView.backgroundColor = UIColor.whiteColor();
        self.capacityBackgroundView.layer.cornerRadius = self.graphView.frame.size.height/2;
        self.capacityBackgroundView.clipsToBounds = true;
        
        if let type = annotation.object["pinType"] as? String{
            if type == "bar"{
                //For Pie Chart
                let items = [PNPieChartDataItem(value: 10, color:blueColor), PNPieChartDataItem(value: 20, color:pinkColor)]
                
                pieChart = PNFilledPieChart(frame: CGRectMake(self.graphView.frame.origin.x, self.graphView.frame.origin.y, self.graphView.frame.size.width, self.graphView.frame.size.height), items: items);
                
                pieChart.descriptionTextColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0);
                pieChart.descriptionTextFont  = UIFont(name: "Avenir-Medium", size: 10.0);
                pieChart.strokeChart();
                
                self.view.addSubview(pieChart);
            }
            else if type == "restaurant"{
                self.rightModuleLabel.text = "Website"
                self.safariButton.hidden = false
            }
        }
        
        self.refreshData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func safariButtonPressed(sender: AnyObject) {
        if let URL = annotation.object["staticPinURL"] as? String{
            UIApplication.sharedApplication().openURL(NSURL(string: URL)!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshData(){
        self.setCrowdLevel();
        if let type = annotation.object["pinType"] as? String{
            if type == "bar"{
                self.setRatio();
            }
        }
    }
    
    func setCrowdLevel(){
        PFCloud.callFunctionInBackground("getLocationCrowdLevel", withParameters: ["lat":self.latitude, "long":self.longitude]) { (response:AnyObject?, error:NSError?) -> Void in
            if(error == nil){
                let responseDict = response as! [String: AnyObject];
                let capacity = responseDict["value"] as! Int;
                if(capacity == -1){
                    self.capacityLabel.hidden = true;
                }
                else{
                    self.capacityLabel.hidden = false;
                }
                self.capacityLabel.text = String(capacity)
//                if let bgColor = response!["backgroundColor"]{
//                    self.capacityBackgroundView.backgroundColor = UIColor(red: bgColor!["red"] as! CGFloat, green: bgColor!["green"] as! CGFloat, blue: bgColor!["blue"] as! CGFloat, alpha: bgColor!["alpha"] as! CGFloat)
//                }
//                if let borderColor = response!["borderColor"]{
//                    self.capacityBackgroundView.layer.borderColor = UIColor(red: borderColor!["red"] as! CGFloat, green: borderColor!["green"] as! CGFloat, blue: borderColor!["blue"] as! CGFloat, alpha: borderColor!["alpha"] as! CGFloat).CGColor
//                }
            }
            else{
                print(error);
            }
        }
    }
    
    func setRatio(){
        PFCloud.callFunctionInBackground("getLocationRatio", withParameters: ["lat":self.latitude, "long":self.longitude]) { (response:AnyObject?, error:NSError?) -> Void in
            if(error == nil){
                let responseDict = response as! [String: AnyObject];
                let femaleCount = responseDict["female"] as! CGFloat;
                let maleCount = responseDict["male"] as! CGFloat;
                let items = [PNPieChartDataItem(value: maleCount, color:self.blueColor), PNPieChartDataItem(value: femaleCount, color:self.pinkColor)]
                self.pieChart.updateChartData(items);
                self.pieChart.strokeChart();
            }
            else{
                print(error);
            }
        }
    }
    
    @IBAction func checkInButtonPressed(sender: AnyObject) {
        let locationManager = LocationManager.sharedLocationManager()
        let pinLocation = CLLocation(latitude: self.latitude.doubleValue, longitude: self.longitude.doubleValue)
        if(locationManager.lastLocation.distanceFromLocation(pinLocation) < 50.0){
            
            let alertController = UIAlertController(title: "Checking in?", message: "We'll let your friends know that you're here!", preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            let okayAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alert:UIAlertAction) -> Void in
                SOBackendUtils.checkInUser(self.annotation.title);
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(okayAction);
            
            self.presentViewController(alertController, animated: true, completion: nil);
        }
        else{
            return UIAlertView(title: "Are you nearby?", message: "You might need to be closer to this location to check in here. Try turning on your wifi for better location accuracy", delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment:"alertOK")).show()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
