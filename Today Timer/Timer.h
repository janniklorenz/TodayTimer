//
//  Timer.h
//  test today
//
//  Created by Jannik Lorenz on 04.06.14.
//  Copyright (c) 2014 Jannik Lorenz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Timer : NSObject <NSCoding>

@property (readwrite) NSString *name;

@property (readwrite) NSDate *targetDate;

- (id)initWithName:(NSString *)n andDate:(NSDate *)date;

@end
