//
//  TodayViewController.m
//  Today Timer
//
//  Created by Jannik Lorenz on 04.06.14.
//  Copyright (c) 2014 Jannik Lorenz. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>


#import "ListRowViewController.h"

#import "Timer.h"

#define NEW_TIMER_NAME @"Neuer Timer"
#define DATA_FILE_NAME @"timers.dat"


@interface TodayViewController () <NCWidgetProviding, NCWidgetListViewDelegate, NCWidgetSearchViewDelegate>

@property (strong) IBOutlet NCWidgetListViewController *listViewController;
@property (strong) NCWidgetSearchViewController *searchController;

@end


@implementation TodayViewController

#pragma mark - NSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up the widget list view controller.
    // The contents property should contain an object for each row in the list.
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex: 0];
    NSString *docFile = [docDir stringByAppendingPathComponent: DATA_FILE_NAME];
    
    self.listViewController.contents = [NSKeyedUnarchiver unarchiveObjectWithFile:docFile];
    
    if (self.listViewController.contents.count == 0) {
        Timer *t = [[Timer alloc] initWithName:NEW_TIMER_NAME andDate:[NSDate date]];
        self.listViewController.contents = [NSArray arrayWithObjects:t, nil];
    }
    
    //    self.listViewController.contents = @[@"Hello World!",@"Hello World!"];
    
}

- (void)dismissViewController:(NSViewController *)viewController {
    [super dismissViewController:viewController];
    
    // The search controller has been dismissed and is no longer needed.
    if (viewController == self.searchController) {
        self.searchController = nil;
    }
}





#pragma mark - ListDingesDelegate

- (void)save {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex: 0];
    NSString *docFile = [docDir stringByAppendingPathComponent:DATA_FILE_NAME];
    
    [NSKeyedArchiver archiveRootObject:self.listViewController.contents toFile: docFile];
}





#pragma mark - NCWidgetProviding

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult result))completionHandler {
    // Refresh the widget's contents in preparation for a snapshot.
    // Call the completion handler block after the widget's contents have been
    // refreshed. Pass NCUpdateResultNoData to indicate that nothing has changed
    // or NCUpdateResultNewData to indicate that there is new data since the
    // last invocation of this method.
    completionHandler(NCUpdateResultNoData);
}

- (NSEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(NSEdgeInsets)defaultMarginInset {
    // Override the left margin so that the list view is flush with the edge.
    defaultMarginInset.left = 0;
    return defaultMarginInset;
}

- (BOOL)widgetAllowsEditing {
    // Return YES to indicate that the widget supports editing of content and
    // that the list view should be allowed to enter an edit mode.
    return YES;
}

- (void)widgetDidBeginEditing {
    // The user has clicked the edit button.
    // Put the list view into editing mode.
    self.listViewController.editing = YES;
}

- (void)widgetDidEndEditing {
    // The user has clicked the Done button, begun editing another widget,
    // or the Notification Center has been closed.
    // Take the list view out of editing mode.
    self.listViewController.editing = NO;
}






#pragma mark - NCWidgetListViewDelegate

- (NSViewController *)widgetList:(NCWidgetListViewController *)list viewControllerForRow:(NSUInteger)row {
    // Return a new view controller subclass for displaying an item of widget
    // content. The NCWidgetListViewController will set the representedObject
    // of this view controller to one of the objects in its contents array.
    
    //    Timer *t = [[Timer alloc] initWithName:@"jasfjaksl" andDate:[NSDate date]];
    
    Timer *t = self.listViewController.contents[row];
    
    ListRowViewController *vc = [[ListRowViewController alloc] initWithTimer: t ];
    vc.delegate = self;
    return vc;
}

- (void)widgetListPerformAddAction:(NCWidgetListViewController *)list {
    // The user has clicked the add button in the list view.
    // Display a search controller for adding new content to the widget.
    //    self.searchController = [[NCWidgetSearchViewController alloc] init];
    //    self.searchController.delegate = self;
    
    // Present the search view controller with an animation.
    // Implement dismissViewController to observe when the view controller
    // has been dismissed and is no longer needed.
    //    [self presentViewControllerInWidget:self.searchController];
    
    NSMutableArray *content = [NSMutableArray arrayWithArray:self.listViewController.contents];
    
    Timer *t = [[Timer alloc] initWithName:NEW_TIMER_NAME andDate:[NSDate date]];
    [content addObject:t];
    
    self.listViewController.contents = [NSArray arrayWithArray:content];
    
    [self save];
    
}

- (BOOL)widgetList:(NCWidgetListViewController *)list shouldReorderRow:(NSUInteger)row {
    // Return YES to allow the item to be reordered in the list by the user.
    return YES;
}

- (void)widgetList:(NCWidgetListViewController *)list didReorderRow:(NSUInteger)row toRow:(NSUInteger)newIndex {
    // The user has reordered an item in the list.
}

- (BOOL)widgetList:(NCWidgetListViewController *)list shouldRemoveRow:(NSUInteger)row {
    // Return YES to allow the item to be removed from the list by the user.
    return YES;
}

- (void)widgetList:(NCWidgetListViewController *)list didRemoveRow:(NSUInteger)row {
    // The user has removed an item from the list.
}








#pragma mark - NCWidgetSearchViewDelegate

- (void)widgetSearch:(NCWidgetSearchViewController *)searchController searchForTerm:(NSString *)searchTerm maxResults:(NSUInteger)max {
    // The user has entered a search term. Set the controller's searchResults property to the matching items.
    searchController.searchResults = @[@"Hello World"]
    ;
}

- (void)widgetSearchTermCleared:(NCWidgetSearchViewController *)searchController {
    // The user has cleared the search field. Remove the search results.
    searchController.searchResults = nil;
}

- (void)widgetSearch:(NCWidgetSearchViewController *)searchController resultSelected:(id)object {
    // The user has selected a search result from the list.
}

@end

