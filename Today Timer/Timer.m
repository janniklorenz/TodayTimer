//
//  Timer.m
//  test today
//
//  Created by Jannik Lorenz on 04.06.14.
//  Copyright (c) 2014 Jannik Lorenz. All rights reserved.
//

#import "Timer.h"

#define NSCODING_NAME @"Timer_name"
#define NSCODING_DATE @"Timer_date"

@implementation Timer


@synthesize name, targetDate;


- (id)initWithName:(NSString *)n andDate:(NSDate *)date {
    self = [super init];
    self.name = n;
    self.targetDate = date;
    return self;
}



- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.name = [coder decodeObjectForKey:NSCODING_NAME];
        self.targetDate = [coder decodeObjectForKey:NSCODING_DATE];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:name forKey:NSCODING_NAME];
    [coder encodeObject:targetDate forKey:NSCODING_DATE];
}



@end
