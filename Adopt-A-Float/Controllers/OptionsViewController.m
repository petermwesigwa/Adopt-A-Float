//
//  OptionsViewController.m
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 8/26/19.
//  Copyright © 2019 Frederik Simons. All rights reserved.
//

#import "OptionsViewController.h"

@interface OptionsViewController ()

@end

extern AppState *appStateManager;

extern NSMutableDictionary<NSNumber *, NSString *> *mapTypes;;

@implementation OptionsViewController
- (void)viewWillAppear:(BOOL)animated {
    [self setup];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source


/*
 Initalize all the labels whenever the screen is rendered
 */
- (void) setup {
    self.mapTypeLabel.text = [OptionsViewController labelForMapViewType:
                              [[appStateManager.mapViewTypes objectAtIndex:
                                appStateManager.selectedMapViewIndex] intValue]];
    self.showPlaces.on = NO;
}

// deprecated
+ (NSString *)labelForMarkerNumber: (NSNumber *)markerNo {
    if ([markerNo intValue] == INT_MAX) {
        return @"All";
    }
    if ([markerNo intValue] == 1) {
        return @"Most Recent";
    }
    return [NSString stringWithFormat:@"Past %d locations", [markerNo intValue]];
}

// String label used for mapViewType
+ (NSString *)labelForMapViewType: (GMSMapViewType)mapType {
    NSNumber *intVal = [NSNumber numberWithInt:(int)mapType];
    NSString *label = [mapTypes objectForKey:intVal];
    return label;
}
@end
