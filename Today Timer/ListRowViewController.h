//
//  ListRowViewController.h
//  Timer
//
//  Created by Jannik Lorenz on 04.06.14.
//  Copyright (c) 2014 Jannik Lorenz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol ListViewControllerDelegate <NSObject>
- (void)save;
@end


@class Timer;

@interface ListRowViewController : NSViewController


#pragma mark - Runtime Vars

/** Editing Indikator */
@property (readwrite) BOOL editing;


/** NSTimer */
@property (readwrite) NSTimer *timer;


/** Timer Name */
//@property (readwrite) NSString *name;


/** Active Instance Of Timer */
@property (readwrite) Timer *activeTimer;









@property (readwrite) id delegate;









#pragma mark - Edit Interface Items

/** Edit Date Picker */
@property (readwrite) IBOutlet NSDatePicker *editDatePicker;


/** Edit Text Field */
@property (readwrite) IBOutlet NSTextField *editTextField;





#pragma mark - Countdown Interface Items

/** Countdown Label */
@property (readwrite) IBOutlet NSTextField *countdownLabel;


/** Countdown Title */
@property (readwrite) IBOutlet NSTextField *countdownTitle;


/** Countdown Detail */
@property (readwrite) IBOutlet NSTextField *countdownDetail;




#pragma mark - init

/** inits a new instance with the given timer */
- (id)initWithTimer:(Timer *)timer;





#pragma mark - Other Interface Stuff

/** Edit Button */
@property (readwrite) IBOutlet NSButton *editButton;





#pragma mark - Update Interface

/** Relaods the Interface elements */
- (void)updateUI;




#pragma mark - Start Stop

/** Action trigged by edit Button */
- (IBAction)editButton:(id)sender;




#pragma mark - Trigger Timer

/** Action trigged by NSTimer to reload the countdown label */
- (void)changeTimer:(id)sender;

/** Creates the NSTImer Instance */
- (void)startTimer;

/** Stops and Kills the NSTimer */
- (void)stopTimer;



@end
