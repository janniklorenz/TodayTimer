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
    
    var refreshTimer: NSTimer?
    
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
        
        self.updateTimer()
        // Insert code here to customize the view
    }
    
    func updateUI() -> (time: NSTimeInterval, acitveTimer: Bool) {
        self.countdownTitle?.stringValue = self.timer.title
        
        var left = self.timer.targetDate.timeIntervalSinceNow;
        if (left > 0) {
            var seconds = left % 60;
            var minutes = (left / 60) % 60;
            var houres  = ((left / 60) / 60) % 24;
            var days    = ((left / 60) / 60) / 24;
            
            var output = ""
            
            var refreshSecond: NSTimeInterval = 60*5
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
                    refreshSecond = 60
                }
                else if (houres == 1) {
                    output += String(format:"%i Stunde ", Int(houres))
                    refreshSecond = 60
                }
                
                if (minutes > 1 && days < 1) {
                    output += String(format:"%i Minuten ", Int(minutes))
                    refreshSecond = 10
                }
                else if (minutes == 1 && days < 1) {
                    output += String(format:"%i Minute ", Int(minutes))
                    refreshSecond = 10
                }
                
                if (seconds > 1 && days < 1 && houres < 1) {
                    output += String(format:"%i Sekunden ", Int(seconds))
                    refreshSecond = 1
                }
                else if (seconds == 1 && days < 1 && houres < 1) {
                    output += String(format:"%i Sekunde ", Int(seconds))
                    refreshSecond = 1
                }
            }
            self.countdownDate?.stringValue = output
            
            return (refreshSecond, true)
        }
        else {
            self.countdownDate?.stringValue = "Fertig"
        }
        return (0, false)
    }
    
    
    
    
    @IBAction func editTimer(sender: NSButton) {
        self.delegate.editTimer(self.timer)
    }
    
    
    
    
    // MARK: - Timer
    
    func updateTimer() {
        var answer: (time: NSTimeInterval, acitveTimer: Bool) = self.updateUI()
        if (answer.acitveTimer) {
            if let t = self.refreshTimer {
                t.invalidate()
            }
            self.refreshTimer = NSTimer.scheduledTimerWithTimeInterval(answer.time, target: self, selector: "updateTimer", userInfo: nil, repeats: false)
        }
        
    }

}
