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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _options.count;
}


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
