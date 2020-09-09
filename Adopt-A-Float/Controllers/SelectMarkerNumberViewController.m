//
//  SelectMarkerNumberViewController.m
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 8/26/19.
//  Copyright © 2019 Frederik Simons. All rights reserved.
//

#import "SelectMarkerNumberViewController.h"

extern AppState *appStateManager;

@interface SelectMarkerNumberViewController ()

@end

@implementation SelectMarkerNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _options = @[@"Most Recent Location", @"Last 5 locations", @"Last 10 Locations", @"Last 20 Locations"];
    _counts = @[@1, @5, @10, @20, @INT_MAX];
}

- (void) viewDidAppear:(BOOL)animated {
    // nothing here yet
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
    return appStateManager.markerNumbers.count;
}


// method needed to implement UITableViewController classs
// populates the rows (cells) for each of the tables
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];
    cell.textLabel.text = [SelectMarkerNumberViewController labelForMarkerNumber:[appStateManager.markerNumbers objectAtIndex:indexPath.row]];
    if (indexPath.row == appStateManager.selectedMarkerNumIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

+ (NSString *)labelForMarkerNumber: (NSNumber *)markerNo {
    if ([markerNo intValue] == INT_MAX) {
        return @"All Locations";
    }
    if ([markerNo intValue] == 1) {
        return @"Most Recent Location";
    }
    return [NSString stringWithFormat:@"Past %d locations", [markerNo intValue]];
}

// This method deselects the previous entry and selects the new entry every time the
// user clicks on a new option
- (NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // deselect the previously selected row
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:
                             [NSIndexPath indexPathForRow:appStateManager.selectedMarkerNumIndex
                                                inSection:0]];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    // set the current cell as the selected cell.
    appStateManager.selectedMarkerNumIndex = (int) indexPath.row;
    cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    return indexPath;
}





@end
