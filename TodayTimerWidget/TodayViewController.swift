//
//  TodayViewController.swift
//  TodayTimerWidget
//
//  Created by Jannik Lorenz on 20.04.15.
//  Copyright (c) 2015 Jannik Lorenz. All rights reserved.
//

import Cocoa
import NotificationCenter

import CoreData

class TodayViewController: NSViewController, NCWidgetProviding, NCWidgetListViewDelegate, TimerViewControllerDelegate, EditTimerViewControllerDelegate {

    @IBOutlet var listViewController: NCWidgetListViewController!
    var searchController: NCWidgetSearchViewController?
    
    var timers: [Timer]
    
    
    
    override init?(nibName: String?, bundle: NSBundle?) {
        MagicalRecord.setupCoreDataStack()
        
        self.timers = Timer.MR_findAllSortedBy("targetDate", ascending: true) as! [Timer]
        super.init(nibName: nibName, bundle: bundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - NSViewController

    override var nibName: String? {
        return "TodayViewController"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
            
        // Set up the widget list view controller.
        // The contents property should contain an object for each row in the list.
        self.listViewController.contents = []
        for timer in self.timers {
            self.listViewController.contents.append(timer.description)
        }

    }
    
    override func dismissViewController(viewController: NSViewController) {
        super.dismissViewController(viewController)

        // The search controller has been dismissed and is no longer needed.
        if viewController == self.searchController {
            self.searchController = nil
        }
    }

    // MARK: - NCWidgetProviding

    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Refresh the widget's contents in preparation for a snapshot.
        // Call the completion handler block after the widget's contents have been
        // refreshed. Pass NCUpdateResultNoData to indicate that nothing has changed
        // or NCUpdateResultNewData to indicate that there is new data since the
        // last invocation of this method.
        completionHandler(.NoData)
    }

    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: NSEdgeInsets) -> NSEdgeInsets {
        var inset = NSEdgeInsetsMake(10, 0, 0, 0)
        return inset
    }

    var widgetAllowsEditing: Bool {
        // Return true to indicate that the widget supports editing of content and
        // that the list view should be allowed to enter an edit mode.
        return true
    }

    func widgetDidBeginEditing() {
        // The user has clicked the edit button.
        // Put the list view into editing mode.
        self.listViewController.editing = true
    }

    func widgetDidEndEditing() {
        // The user has clicked the Done button, begun editing another widget,
        // or the Notification Center has been closed.
        // Take the list view out of editing mode.
        self.listViewController.editing = false
    }

    // MARK: - NCWidgetListViewDelegate

    func widgetList(list: NCWidgetListViewController!, viewControllerForRow row: Int) -> NSViewController! {
        // Return a new view controller subclass for displaying an item of widget
        // content. The NCWidgetListViewController will set the representedObject
        // of this view controller to one of the objects in its contents array.
        return TimerViewController(timer: self.timers[row] , delegate: self)
    }

    func widgetListPerformAddAction(list: NCWidgetListViewController!) {
        // The user has clicked the add button in the list view.
        // Display a search controller for adding new content to the widget.
//        self.searchController = NCWidgetSearchViewController()
//        self.searchController!.delegate = self

        // Present the search view controller with an animation.
        // Implement dismissViewController to observe when the view controller
        // has been dismissed and is no longer needed.
//        self.presentViewControllerInWidget(self.searchController)
        
        
        MagicalRecord.saveWithBlockAndWait { (localContext: NSManagedObjectContext!) -> Void in
            var timer = Timer.MR_createInContext(localContext) as! Timer
            timer.title = "Test"
            localContext.MR_saveToPersistentStoreWithCompletion({ (success: Bool, error: NSError!) -> Void in
                self.timers = Timer.MR_findAllSortedBy("targetDate", ascending: true) as! [Timer]
//                self.timers.append(timer)
                self.listViewController.contents.append(timer.description)
            })
        }
        
//        self.updateList()
    }

    func widgetList(list: NCWidgetListViewController!, shouldReorderRow row: Int) -> Bool {
        // Return true to allow the item to be reordered in the list by the user.
        return false
    }

    func widgetList(list: NCWidgetListViewController!, didReorderRow row: Int, toRow newIndex: Int) {
        // The user has reordered an item in the list.
    }

    func widgetList(list: NCWidgetListViewController!, shouldRemoveRow row: Int) -> Bool {
        // Return true to allow the item to be removed from the list by the user.
        return true
    }
    
    func widgetList(list: NCWidgetListViewController!, didRemoveRow row: Int) {
        MagicalRecord.saveWithBlockAndWait { (localContext: NSManagedObjectContext!) -> Void in
            var timer = self.timers[row].MR_inContext(localContext) as! Timer
            timer.MR_deleteInContext(localContext)
            localContext.MR_saveToPersistentStoreWithCompletion({ (success: Bool, error: NSError!) -> Void in
                self.timers.removeAtIndex(row)
//                self.timers = Timer.MR_findAll() as! [Timer]
//                self.listViewController.contents.removeAtIndex(row)
            })
        }
    }
    
    
    
    
    // MARK: - TimerViewControllerDelegate
    
    func editTimer(timer: Timer) {
        var editVC = EditTimerViewController(timer: timer, delegate: self)
        self.presentViewControllerInWidget(editVC)
    }
    
    
    
    // MARK: - EditTimerViewControllerDelegate
    
    func doneEditTimer(timer: Timer) {
        var index = find(self.timers, timer)!
        self.timers = Timer.MR_findAllSortedBy("targetDate", ascending: true) as! [Timer]
        self.listViewController.contents[index] = timer.description
//        self.timers[index] = timer
//        self.updateList()
    }

    
    
}
