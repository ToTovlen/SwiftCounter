//
//   CounterViewController.swift
//  SwiftCounter
//
//  Created by Yosemite Retail on 15/8/30.
//  Copyright (c) 2015年 Yosemite Retail. All rights reserved.
//

import Foundation
import UIKit

class CounterViewController:UIViewController{
    //UI Controls
    var timeLabel:UILabel?
    var timeButtons:[UIButton]?
    var startStopButton:UIButton?
    var clearButton:UIButton?
    
    //Button info
    let timeButtonInfos=[("1分钟",60),("3分钟",180),("5分钟",300),("秒",1)]
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.view.backgroundColor=UIColor.whiteColor()
        setupTimeLabel()
        setupTimeButtons()
        setupActionButtons()
    }
    
    
    func setupTimeLabel(){
        timeLabel=UILabel()
        timeLabel!.textColor=UIColor.whiteColor()
        
        timeLabel!.backgroundColor=UIColor.blackColor()
        timeLabel!.font=UIFont(name: "adc", size: 80)
        timeLabel!.textAlignment=NSTextAlignment.Center
        
        self.view.addSubview(timeLabel!)
    }
    
    func setupTimeButtons(){
        var buttons:[UIButton]=[]
        var button:UIButton?
        
        for (index,(title,_)) in enumerate(timeButtonInfos){
            button=UIButton()
            
            button!.tag=index
            button!.setTitle("\(title)", forState: UIControlState.Normal)
            button!.backgroundColor=UIColor.orangeColor()
            button!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            button!.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
            button!.addTarget(self, action: "timeButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            
            buttons.append(button!)
            self.view.addSubview(button!)
        }
        
        timeButtons=buttons
    }
    
    func setupActionButtons(){
        startStopButton=UIButton()
        startStopButton!.backgroundColor=UIColor.redColor()
        startStopButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        startStopButton!.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        startStopButton!.setTitle("启动／停止", forState: UIControlState.Normal)
        startStopButton!.addTarget(self, action: "startStopButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(startStopButton!)
        
        clearButton=UIButton()
        clearButton!.backgroundColor=UIColor.redColor()
        clearButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        clearButton!.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        clearButton!.setTitle("复位", forState: UIControlState.Normal)
        clearButton!.addTarget(self, action: "clearButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(clearButton!)
    
    }
    
    func timeButtonTapped(sender:UIButton){
        let (_,seconds)=timeButtonInfos[sender.tag]
        remainingSeconds=seconds
    }
    
    func startStopButtonTapped(sender:UIButton){
        isCounting = !isCounting
    }
    
    func clearButtonTapped(sender:UIButton){
        remainingSeconds=0
        timer?.invalidate()
        timer=nil
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        timeLabel!.frame=CGRectMake(10, 40, self.view.bounds.width-20, 120)
        
        let gap=(self.view.bounds.size.width - 10*2-CGFloat(timeButtons!.count*64))/CGFloat(timeButtons!.count-1)
        
        for (index,button) in enumerate(timeButtons!){
            let buttonLeft=10+(64+gap) * CGFloat(index)
            button.frame=CGRectMake(buttonLeft, self.view.bounds.size.height-120, 64, 44)
        }
        
        startStopButton!.frame=CGRectMake(10,self.view.bounds.size.height-60, self.view.bounds.size.width-20-100, 44)
        clearButton!.frame=CGRectMake(10+self.view.bounds.size.width-100, self.view.bounds.size.height-60, 80, 44)
    }
    
    var remainingSeconds:Int=0{
        willSet(newSeconds){
            let mins=newSeconds/60
            let seconds=newSeconds%60
            self.timeLabel!.text=NSString(format: "%02d:%02d", mins,seconds) as String
        }
    }
    
    var isCounting:Bool=false{
        willSet(newValue){
            if newValue{
                timer=NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
            }else{
                timer?.invalidate()
                timer=nil
            }
            
            setSettingButtonsEnabled(newValue)
        }
    }
    var timer:NSTimer?
    
    func updateTimer(){
        if remainingSeconds<=0{
            let alert=UIAlertView()
            alert.title="计时完成"
            alert.message="很好。。"
            alert.addButtonWithTitle("OK")
            alert.show()
            
            timer?.invalidate()
            timer=nil
            return
            
        }
        remainingSeconds-=1
    }
    
    func setSettingButtonsEnabled(enabled:Bool){
        for button in self.timeButtons!{
            button.enabled=enabled
            button.alpha = enabled ? 1.0 : 0.3
        }
        clearButton!.enabled=enabled
        clearButton!.alpha = enabled ? 1.0 : 0.3
    }
}
