//
//  SelectMarkerNumberViewController.h
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 8/26/19.
//  Copyright © 2019 Frederik Simons. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/*
 Display the optiosn of choosing the history of each marker to display on the screen
 (how many points to display in the pasy)
 This class inherits from UITableViewController and as such is implemented as a table with each row displaying a selection option for the user
 */
@interface SelectMarkerNumberViewController : UITableViewController

// Options available are the past 1, 5, 10 and 20 locations
@property (strong) NSArray<NSString*> *options;

// Numbers 1, 5, 10, and 20 corresponding to each of the options
@property (strong) NSArray<NSNumber*> *counts;

// keep track of currently selected option
@property (assign) int selectedMarkerNumberIndex;

// value of currently selected option
@property (assign) int markerNumber;


@end

NS_ASSUME_NONNULL_END
