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

@implementation OptionsViewController
- (void)viewDidAppear:(BOOL)animated {
    self.currentInstrumentLabel.text = self.currentInstrument;
    self.markerNumberLabel.text = [NSString stringWithFormat:@"Past %d location(s)", _markerNumber];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SelectCurrentInstrument"]) {
        SelectFloatTableViewController * destination = segue.destinationViewController;
        destination.instruments = _instruments;
        destination.selectedFloat = _currentInstrument;
        destination.selectedFloatIndex = _currentFloatNameIndex;
    } else if ([segue.identifier isEqualToString:@"SelectHistory"]) {
        SelectMarkerNumberViewController *dest = segue.destinationViewController;
        dest.selectedMarkerNumberIndex = self.currentMarkerNumberIndex;
    }
}

- (IBAction)discardChanges:(UIStoryboardSegue*)unwindSegue {
    
}

- (IBAction)changeMarkerNumber: (UIStoryboardSegue*)unwindSegue {
    SelectMarkerNumberViewController *source = unwindSegue.sourceViewController;
    self.currentMarkerNumberIndex = source.selectedMarkerNumberIndex;
    self.markerNumber = source.markerNumber;
    self.markerNumberLabel.text = [NSString stringWithFormat:@"%d", source.markerNumber];
}

- (IBAction)changeFloatName:(UIStoryboardSegue*)unwindSegue {
    SelectFloatTableViewController *source = unwindSegue.sourceViewController;
    self.currentInstrument = source.selectedFloat;
    self.currentFloatNameIndex = source.selectedFloatIndex;
    self.currentInstrumentLabel.text = source.selectedFloat;
}
@end
