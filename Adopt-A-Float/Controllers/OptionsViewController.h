//
//  OptionsViewController.h
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 8/26/19.
//  Copyright © 2019 Frederik Simons. All rights reserved.
//

/*
 This is the controller for the Options Screen navigated to from the map
 Inherits from UITableViewController
 */
#import <UIKit/UIKit.h>
#import "AppState.h"

NS_ASSUME_NONNULL_BEGIN

@interface OptionsViewController : UITableViewController

// name of the current istrument on display (eg 'P007') or 'All' if all instruments being shown
@property (strong) NSString *currentInstrument;

// names of all the instruments
@property (strong) NSMutableArray<NSString*>* instruments;

// keeps track of which float is being displayed
@property (assign) int currentFloatNameIndex;

// keep track of the currently selected marker number option
@property (assign) int currentMarkerNumberIndex;

// currently selected number of markers to display
@property (assign) int markerNumber;

// display element showing the name of the current instrument displayed (or 'All' if all instruments shown
@property (weak, nonatomic) IBOutlet UILabel *currentInstrumentLabel;

// display element showing current number of past data points being displayed
@property (weak, nonatomic) IBOutlet UILabel *markerNumberLabel;



@end

NS_ASSUME_NONNULL_END