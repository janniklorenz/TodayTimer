//
//  ListRowViewController.m
//  Timer
//
//  Created by Jannik Lorenz on 04.06.14.
//  Copyright (c) 2014 Jannik Lorenz. All rights reserved.
//

#import "ListRowViewController.h"

#import "Timer.h"

@implementation ListRowViewController

@synthesize editing, timer, activeTimer;
@synthesize editDatePicker, editTextField;
@synthesize countdownLabel, countdownTitle, countdownDetail;
@synthesize editButton;




#pragma mark - init

- (id)initWithTimer:(Timer *)t {
    self = [super init];
    self.activeTimer = t;
    return self;
}






- (NSString *)nibName {
    return @"ListRowViewController";
}

- (void)loadView {
    [super loadView];
    
    // Insert code here to customize the view
    [self updateUI];
    
    [self changeTimer:nil];
    
}





#pragma mark - Update Interface

- (void)updateUI {
    
    // Show/ Hide item
    self.countdownLabel.hidden =    self.editing;
    self.countdownDetail.hidden =   self.editing;
    self.countdownTitle.hidden =    self.editing;
    
    self.editDatePicker.hidden =    !self.editing;
    self.editTextField.hidden =     !self.editing;
    
    
    // Update Values
    self.editDatePicker.minDate = [NSDate date];
    
    self.countdownDetail.stringValue = self.activeTimer.targetDate.description;
    
    if (self.activeTimer.targetDate) {
        self.editDatePicker.dateValue = self.activeTimer.targetDate;
    }
    
    if (self.activeTimer.name) {
        self.countdownTitle.stringValue = self.activeTimer.name;
        self.editTextField.stringValue = self.activeTimer.name;
    }
}






#pragma mark - Start Stop

- (IBAction)editButton:(id)sender {
    
    // Save
    if (self.editing) {
        self.activeTimer.name = self.editTextField.stringValue;
        self.activeTimer.targetDate = self.editDatePicker.dateValue;
    }
    
    
    // Change State
    self.editing = !self.editing;
    
    
    // Update UI
    [self updateUI];
    
    
    // Start Stop Counting
    if (self.editing) [self stopTimer];
    else [self startTimer];
    
    [self.delegate save];
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docDir = [paths objectAtIndex: 0];
//    NSString *docFile = [docDir stringByAppendingPathComponent: @"deck.txt"];
//    
//    NSLog(@"%@", docFile);
//    
////    [self.activeTimer writeToFile:docFile atomically:YES encoding:NSUTF8StringEncoding error:&error];
//    
//    
//    [NSKeyedArchiver archiveRootObject:self.activeTimer toFile: docFile];
//    
//    
//        NSLog(@"====== %@", [(Timer *)[NSKeyedUnarchiver unarchiveObjectWithFile:docFile] targetDate]);
    
}







#pragma mark - Trigger Timer

- (void)changeTimer:(id)sender {
    
    int left = self.activeTimer.targetDate.timeIntervalSinceNow;
    
    if (left > 0) {
        
        
        int seconds = left % 60;
        int minutes = (left / 60) % 60;
        int houres  = ((left / 60) / 60) % 24;
        int days    = ((left / 60) / 60) / 24;
        
        NSString *output = @"";
        
        if (days > 10) {
            output = days > 1 ? [NSString stringWithFormat:@"%@%i Tage", output, days] :
                    days == 1 ? [NSString stringWithFormat:@"%@%i Tag", output, days] : @"";
            
        }
        else {
            output = days > 1 ? [NSString stringWithFormat:@"%@%i Tage ", output, days] :
                    days == 1 ? [NSString stringWithFormat:@"%@%i Tag ", output, days] : @"";
            
            output = houres > 1 ? [NSString stringWithFormat:@"%@%i Stunden ", output, houres] :
                    houres == 1 ? [NSString stringWithFormat:@"%@%i Stunde ", output, houres] : @"";
            
            if (days == 0) output = minutes > 1 ? [NSString stringWithFormat:@"%@%i Minuten ", output, minutes] :
                                    minutes == 1 ? [NSString stringWithFormat:@"%@%i Minute ", output, minutes] : @"";
            
            if (houres == 0)
                output = seconds > 1 ? [NSString stringWithFormat:@"%@%i Sekunden ", output, seconds] :
                        seconds == 1 ? [NSString stringWithFormat:@"%@%i Sekunde ", output, seconds] : @"";
        }
        
        
        [self.countdownLabel setStringValue:output];
        
    }
    else {
//        [self.countdownLabel setStringValue:@"Fertig"];
        self.editing = YES;
        [self updateUI];
        [self stopTimer];
    }
}


- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(changeTimer:) userInfo:nil repeats:YES];
    [self changeTimer:nil];
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}


@end
