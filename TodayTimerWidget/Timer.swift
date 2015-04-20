//
//  Timer.swift
//  TodayTimer
//
//  Created by Jannik Lorenz on 20.04.15.
//  Copyright (c) 2015 Jannik Lorenz. All rights reserved.
//

import Foundation
import CoreData

@objc(Timer) class Timer: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var targetDate: NSDate

}
