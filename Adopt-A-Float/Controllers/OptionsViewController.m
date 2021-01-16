//
//  OptionsViewController.m
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 8/26/19.
//  Copyright © 2019 Frederik Simons. All rights reserved.
//

#import "OptionsViewController.h"
#import "SelectFloatTableViewController.h"
#import "SelectMarkerNumberViewController.h"

@interface OptionsViewController ()

@end

extern AppState *appStateManager;

extern NSMutableDictionary<NSNumber *, NSString *> *mapTypes;;

@implementation OptionsViewController
- (void)viewDidAppear:(BOOL)animated {
    [self setup];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

// Prepare for segue into either the Select Instrumment Screen or seleec
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // segueing into Select Float Name screen
    if ([segue.identifier isEqualToString:@"SelectCurrentInstrument"]) {
        SelectFloatTableViewController * destination = segue.destinationViewController;
        destination.instruments = _instruments;
        destination.selectedFloat = _currentInstrument;
        destination.selectedFloatIndex = _currentFloatNameIndex;
    }
    // segueing into select history number screen
    else if ([segue.identifier isEqualToString:@"SelectHistory"]) {
        SelectMarkerNumberViewController *dest = segue.destinationViewController;
        dest.selectedMarkerNumberIndex = self.currentMarkerNumberIndex;
    }
}

/*
 All the unwind segues are currently empty. Might be able to condense them into one
 */

- (IBAction)discardChanges:(UIStoryboardSegue*)unwindSegue {
    
}

// change marker number with user selection from select marker number s
- (IBAction)changeMarkerNumber: (UIStoryboardSegue*)unwindSegue {
//    self.currentMarkerNumberIndex = appStateManager.selectedMarkerNumIndex;
//    self.markerNumberLabel.text = [OptionsViewController labelForMarkerNumber:[appStateManager.markerNumbers objectAtIndex:appStateManager.selectedMarkerNumIndex]];
}

- (IBAction)changeMapType: (UIStoryboardSegue*) unwindSegue {
//    GMSMapViewType type = [[appStateManager.mapViewTypes objectAtIndex:appStateManager.selectedMapViewIndex] intValue];
//    self.mapTypeLabel.text = [OptionsViewController labelForMapViewType:type];
}

- (IBAction)changeFloatName:(UIStoryboardSegue*)unwindSegue {
//    SelectFloatTableViewController *source = unwindSegue.sourceViewController;
//    self.currentInstrument = source.selectedFloat;
//    self.currentFloatNameIndex = source.selectedFloatIndex;
//    self.currentInstrumentLabel.text = self.currentInstrument;
}

//----------------------------------------------------------------------------------


/*
 Initalize all the labels whenever the screen is rendered
 */
- (void) setup {
    self.currentInstrument = appStateManager.selectedInstr;
    self.currentInstrumentLabel.text = self.currentInstrument;
    self.markerNumberLabel.text = [OptionsViewController labelForMarkerNumber:
                                   [appStateManager.markerNumbers objectAtIndex:
                                    appStateManager.selectedMarkerNumIndex]];
    self.mapTypeLabel.text = [OptionsViewController labelForMapViewType:
                              [[appStateManager.mapViewTypes objectAtIndex:
                                appStateManager.selectedMapViewIndex] intValue]];
    self.showPlaces.on = NO;
}

+ (NSString *)labelForMarkerNumber: (NSNumber *)markerNo {
    if ([markerNo intValue] == INT_MAX) {
        return @"All";
    }
    if ([markerNo intValue] == 1) {
        return @"Most Recent";
    }
    return [NSString stringWithFormat:@"Past %d locations", [markerNo intValue]];
}

+ (NSString *)labelForMapViewType: (GMSMapViewType)mapType {
    NSNumber *intVal = [NSNumber numberWithInt:(int)mapType];
    NSString *label = [mapTypes objectForKey:intVal];
    return label;
}
@end
