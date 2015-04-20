//
//  ListRowViewController.swift
//  TodayTimerWidget
//
//  Created by Jannik Lorenz on 20.04.15.
//  Copyright (c) 2015 Jannik Lorenz. All rights reserved.
//

import Cocoa

protocol EditTimerViewControllerDelegate {
    func doneEditTimer(timer: Timer)
}

class EditTimerViewController: NSViewController {
    
    var timer: Timer
    var delegate: EditTimerViewControllerDelegate
    
    @IBOutlet var titleField: NSTextField?
    @IBOutlet var dateField: NSDatePicker?
    
    required init?(timer: Timer, delegate: EditTimerViewControllerDelegate) {
        self.timer = timer
        self.delegate = delegate
        
        super.init(nibName: "EditTimerViewController", bundle: NSBundle.mainBundle())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var nibName: String? {
        return "EditTimerViewController"
    }

    override func loadView() {
        super.loadView()
        
        self.preferredContentSize = NSSize(width: self.view.frame.size.width, height: 153)
        
        self.titleField?.stringValue = self.timer.title
        self.dateField?.dateValue = self.timer.targetDate
        self.dateField?.minDate = NSDate()
        
        // Insert code here to customize the view
    }
    
    
    
    
    @IBAction func done(sender: AnyObject) {
        MagicalRecord.saveWithBlockAndWait { (localContext: NSManagedObjectContext!) -> Void in
            var timer = self.timer.MR_inContext(localContext) as! Timer
            if let title = self.titleField?.stringValue {
                timer.title = title
            }
            if let targetDate = self.dateField?.dateValue {
                timer.targetDate = targetDate
            }
            localContext.MR_saveToPersistentStoreAndWait()
        }
        
        self.delegate.doneEditTimer(self.timer)
        self.dismissViewController(self)
    }

}
