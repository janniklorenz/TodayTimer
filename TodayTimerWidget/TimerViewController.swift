//
//  ListRowViewController.swift
//  TodayTimerWidget
//
//  Created by Jannik Lorenz on 20.04.15.
//  Copyright (c) 2015 Jannik Lorenz. All rights reserved.
//

import Cocoa

protocol TimerViewControllerDelegate {
    func editTimer(timer: Timer)
}

class TimerViewController: NSViewController {
    
    var timer: Timer
    var delegate: TimerViewControllerDelegate
    
    @IBOutlet var countdownDate: NSTextField?
    @IBOutlet var countdownTitle: NSTextField?
    
    required init?(timer: Timer, delegate: TimerViewControllerDelegate) {
        self.timer = timer
        self.delegate = delegate
        
        super.init(nibName: "TimerViewController", bundle: NSBundle.mainBundle())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var nibName: String? {
        return "TimerViewController"
    }

    override func loadView() {
        super.loadView()
        
        self.countdownTitle?.stringValue = self.timer.title
        
        
        
        var left = self.timer.targetDate.timeIntervalSinceNow;
        if (left > 0) {
            var seconds = left % 60;
            var minutes = (left / 60) % 60;
            var houres  = ((left / 60) / 60) % 24;
            var days    = ((left / 60) / 60) / 24;
            
            var output = ""
            
            if (days > 10) {
                if (days > 1) {
                    output += String(format:"%i Tage ", Int(days))
                }
                else if (days == 1) {
                    output += String(format:"%i Tag ", Int(days))
                }
            }
            else {
                if (days > 1) {
                    output += String(format:"%i Tage ", Int(days))
                }
                else if (days == 1) {
                    output += String(format:"%i Tag ", Int(days))
                }
                
                if (houres > 1) {
                    output += String(format:"%i Stunden ", Int(houres))
                }
                else if (houres == 1) {
                    output += String(format:"%i Stunde ", Int(houres))
                }
                
                if (minutes > 1 && days == 0) {
                    output += String(format:"%i Minuten ", Int(minutes))
                }
                else if (minutes == 1 && days == 0) {
                    output += String(format:"%i Minute ", Int(minutes))
                }
                
                if (seconds > 1 && days == 0 && houres == 0) {
                    output += String(format:"%i Sekunden ", Int(seconds))
                }
                else if (seconds == 1 && days == 0 && houres == 0) {
                    output += String(format:"%i Sekunde ", Int(seconds))
                }
            }
            self.countdownDate?.stringValue = output
        }
        
        // Insert code here to customize the view
    }
    
    
    
    
    @IBAction func editTimer(sender: NSButton) {
        self.delegate.editTimer(self.timer)
    }

}
