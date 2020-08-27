//
//  SelectFloatTableViewController.m
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 8/26/19.
//  Copyright © 2019 Frederik Simons. All rights reserved.
//

#import "SelectFloatTableViewController.h"

@interface SelectFloatTableViewController ()

@end

@implementation SelectFloatTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// needed for implementation of UITableViewController class
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _instruments.count;
}

// needed for implementation of UITableViewController class
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InstrumentNameCell" forIndexPath:indexPath];
    cell.textLabel.text = [_instruments objectAtIndex:indexPath.row];
    if (indexPath.row == _selectedFloatIndex) {
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
                             [NSIndexPath indexPathForRow:_selectedFloatIndex inSection:0]];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    // set the current cell as the selected cell.
    _selectedFloat = [_instruments objectAtIndex:indexPath.row];
    _selectedFloatIndex = (int) indexPath.row;
    cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    return indexPath;
}
@end
