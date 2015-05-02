//
//  main.swift
//  TodayTimerCli
//
//  Created by Jannik Lorenz on 21.04.15.
//  Copyright (c) 2015 Jannik Lorenz. All rights reserved.
//

import Foundation

println("Hello, World!")



extension NSBundle {
    var __bundleIdentifier: String {
        get {
            if self == NSBundle.mainBundle() {
                return "com.apple.finder"
            }
        }
    }
}


var ccc = objc_getClass("NSBundle")

class_getInstanceMethod(cls: ccc, name: "fff")

method_exchangeImplementations(class_getInstanceMethod(c, bundleIdentifier), class_getInstanceMethod(c, "__bundleIdentifier"))


var notification = NSUserNotification()
notification.title = "Hello, World!"
notification.informativeText = "A notification"
notification.soundName = NSUserNotificationDefaultSoundName;
//        notification.otherButtonTitle = "dddd"
//        notification.actionButtonTitle = "dd"

NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notification)









//MagicalRecord.setupAutoMigratingCoreDataStack()
//
//var timers = Timer.MR_findAll() as! [Timer]
//
//println(timers.count)

//for timer in (Timer.MR_findAll() as! [Timer]) {
//    var s = "+++++++" + timer.title
//    println(s)
//}cod