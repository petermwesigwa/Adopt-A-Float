//
//  SelectMarkerNumberViewController.m
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 8/26/19.
//  Copyright © 2019 Frederik Simons. All rights reserved.
//

#import "SelectMarkerNumberViewController.h"

@interface SelectMarkerNumberViewController ()

@end

@implementation SelectMarkerNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _options = @[@"Most Recent Location", @"Last 5 locations", @"Last 10 Locations", @"Last 20 Locations"];
    _counts = @[@1, @5, @10, @20];
}

#pragma mark - Table view data source
// method needed to implement UITableViewController class
// Returns the number of sections in the table (in this case this number should be 1)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// method needed to impolement UITableViewController class
// Returns the number of rows in the table (one row for each entry)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _options.count;
}


// method needed to implement UITableViewController classs
// populates the rows (cells) for each of the tables
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];
    cell.textLabel.text = [_options objectAtIndex:indexPath.row];
    if (indexPath.row == _selectedMarkerNumberIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

// This method deselects the previous entry and selects the new entry every time the
// user clicks on a new option
- (NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // deselect the previously selected row
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:
                             [NSIndexPath indexPathForRow:_selectedMarkerNumberIndex
                                                inSection:0]];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    // set the current cell as the selected cell.
    _selectedMarkerNumberIndex = (int) indexPath.row;
    _markerNumber = [self.counts objectAtIndex:indexPath.row].intValue;
    cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    return indexPath;
    return indexPath;
}





@end
