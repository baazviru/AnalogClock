//
//  ViewController.swift
//  Analog Clocks
//
//  Created by virendra kumar on 15/04/21.
//  Copyright © 2021 mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var secondView:UIView!
    @IBOutlet weak var minuteView:UIView!
    @IBOutlet weak var hourView:UIView!
    
    @IBOutlet weak var secondV:UIView!
    @IBOutlet weak var minuteV:UIView!
    @IBOutlet weak var hourV:UIView!
    
    var timer : Timer?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        secondV.layer.cornerRadius = 5.0
        secondV.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        minuteV.layer.cornerRadius = 7.0
        minuteV.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        hourV.layer.cornerRadius = 9.0
        hourV.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        setInitialTimeUI()

    }
    override func viewWillAppear(_ animated: Bool) {
      //  StartClockAnimation()
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.rotate), userInfo: nil, repeats: true)
        }
    }
  //MARK:- Call this function in viewDidload to set current Time
    
    func setInitialTimeUI(){
        
        let date = Date()
        let currentSecond = CGFloat(Int(stringFromDate(date: date, format: "ss"))!)
        let secondRadians = currentSecond*6 / 180.0 * CGFloat.pi
        let rotationSecond = secondView.transform.rotated(by: secondRadians)
        secondView.transform = rotationSecond
        
        let currentMinute = CGFloat(Int(stringFromDate(date: date, format: "mm"))!)
        let minuteRadians = currentMinute*6 / 180.0 * CGFloat.pi
        let rotationMinute = minuteView.transform.rotated(by: minuteRadians)
        minuteView.transform = rotationMinute
        let currentHour = CGFloat(Int(stringFromDate(date: date, format: "hh"))!)
        
        //MARK:- hour Position according miniute so it is calculation of ration between two hours like 7 to 8
      
        let ratio = CGFloat(currentMinute) / 60
        let hourRadians = (ratio+currentHour)*30 / 180.0 * CGFloat.pi
        let rotationHour = hourView.transform.rotated(by: hourRadians)
        hourView.transform = rotationHour
    }

     func stringFromDate(date:Date,format:String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }

//MARK:- This Function Change the second, minute, and hour position
   
    @objc func rotate() {
        
        //MARK:- second rotate formula ///   (6 * CGFloat.pi/180)
        //MARK:- Minute rotate formula ///  (6 * CGFloat.pi/180)/60
        //MARK:- Hour rotate formula ///    ((30 * CGFloat.pi/180)/60)/60
        
        let secondRadians = 6 * CGFloat.pi/180
        let minuteRadians = (6 * CGFloat.pi/180)/60
        let hourRadians = ((30 * CGFloat.pi/180)/60)/60

        let rotationSecond = secondView.transform.rotated(by: secondRadians)
        secondView.transform = rotationSecond
        let rotationMinute = minuteView.transform.rotated(by: minuteRadians)
        minuteView.transform = rotationMinute
        let rotationHour = hourView.transform.rotated(by: hourRadians)
        hourView.transform = rotationHour
       
    }
    

    func StartClockAnimation() {
        
        //MARK:- second Animation  from current second
        let currentSecond = CGFloat(Int(stringFromDate(date: Date(), format: "ss"))!)
        let secondRadians = currentSecond*6 / 180.0 * CGFloat.pi
        let secondAnimation = setUpLayerAnimation(duration: 60, isRemovedOnCompletion: false, timingFunction: CAMediaTimingFunction(name: .linear), fromValue: secondRadians, byValue: (2 * Double.pi))
        secondView.layer.add(secondAnimation, forKey: Clock.AnimationKey.second)
        
        //MARK:- Minute Animation from current minute
        let currentMinute = CGFloat(Int(stringFromDate(date: Date(), format: "mm"))!)
        let minuteRadians = currentMinute*6 / 180.0 * CGFloat.pi
        let minuteAnimation = setUpLayerAnimation(duration: 60*60, isRemovedOnCompletion: false, timingFunction: CAMediaTimingFunction(name: .linear), fromValue: minuteRadians, byValue: 2 * Double.pi)
        minuteView.layer.add(minuteAnimation, forKey: Clock.AnimationKey.minute)
        
       //MARK:- Hour Animation from current hour
        let currentHour = CGFloat(Int(stringFromDate(date: Date(), format: "hh"))!)
        let ratio = CGFloat(currentMinute) / 60
        let hourRadians = (ratio+currentHour)*30 / 180.0 * CGFloat.pi
        let hourAnimation = setUpLayerAnimation(duration: 60*60*12, isRemovedOnCompletion: false, timingFunction: CAMediaTimingFunction(name: .linear), fromValue: hourRadians, byValue: 2 * Double.pi)
        hourView.layer.add(hourAnimation, forKey: Clock.AnimationKey.hour)
    }
 
    func setUpLayerAnimation(keyPath: String = Clock.AnimationKey.path, repeatCount: Float = .infinity, duration: CFTimeInterval, isRemovedOnCompletion: Bool, timingFunction: CAMediaTimingFunction?, fromValue: Any?, byValue: Any?) -> CABasicAnimation {
        let animation = CABasicAnimation()
        animation.keyPath = keyPath
        animation.repeatCount = repeatCount
        animation.duration = duration
        animation.isRemovedOnCompletion = isRemovedOnCompletion
        animation.timingFunction = timingFunction
        animation.fromValue = fromValue
        animation.byValue = byValue
        return animation
    }
}


struct Clock {
    private init() {}
    struct AnimationKey {
        private init() {}
        static let path = "transform.rotation.z"
        static let second = "SecondAnimationKey"
        static let minute = "MinuteAnimationKey"
        static let hour = "HourAnimationKey"
    }
}


