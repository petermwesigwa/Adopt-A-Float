//
//  SelectFloatTableViewController.m
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 8/26/19.
//  Copyright © 2019 Frederik Simons. All rights reserved.
//

#import "SelectFloatTableViewController.h"

extern AppState *appStateManager;

@interface SelectFloatTableViewController ()

@end

@implementation SelectFloatTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:appStateManager.selectedInstrIndex inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// needed for implementation of UITableViewController class
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return appStateManager.instrNames.count;
}

// needed for implementation of UITableViewController class
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InstrumentNameCell" forIndexPath:indexPath];
    cell.textLabel.text = [appStateManager.instrNames objectAtIndex:indexPath.row];
    if (indexPath.row == appStateManager.selectedInstrIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

// needed for implementation of UITableViewController class
- (NSIndexPath *)tableView:(UITableView*)tableView willSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    // deselect the previously selected row
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:
                             [NSIndexPath indexPathForRow:appStateManager.selectedInstrIndex inSection:0]];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    // set the current cell as the selected cell.
    appStateManager.selectedInstrIndex = (int) indexPath.row;
    appStateManager.selectedInstr = [appStateManager.instrNames objectAtIndex:indexPath.row];
    cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    return indexPath;
}
@end
