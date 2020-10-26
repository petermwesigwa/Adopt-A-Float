//
//  SelectMapTypeScreen.m
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 10/26/20.
//  Copyright © 2020 Frederik Simons. All rights reserved.
//

#import "SelectMapTypeScreen.h"

@interface SelectMapTypeScreen ()

@end

extern AppState *appStateManager;

@implementation SelectMapTypeScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mapTypes = [NSArray arrayWithObjects:
                         [NSNumber numberWithInt:kGMSTypeHybrid],
                         [NSNumber numberWithInt:kGMSTypeSatellite],
                         [NSNumber numberWithInt:kGMSTypeNormal],
                         [NSNumber numberWithInt:kGMSTypeTerrain],nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_mapTypes count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectMapTypeCell" forIndexPath:indexPath];
    
    GMSMapViewType type=[[appStateManager.mapViewTypes objectAtIndex:indexPath.row] intValue];
    
    cell.textLabel.text = [SelectMapTypeScreen labelForMapViewType:type];
    
    if (appStateManager.selectedMapViewIndex == (int) indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *oldSelection = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:appStateManager.selectedMapViewIndex inSection:0]];
    oldSelection.accessoryType = UITableViewCellAccessoryNone;
    
    UITableViewCell *newSelection = [tableView cellForRowAtIndexPath:indexPath];
    newSelection.accessoryType = UITableViewCellAccessoryCheckmark;
    
    appStateManager.selectedMapViewIndex = (int) indexPath.row;
    
    return indexPath;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

+ (NSString *)labelForMapViewType: (GMSMapViewType)mapType {
    if (mapType == kGMSTypeHybrid) {
        return @"Satellite with Labels";
    }
    if (mapType == kGMSTypeNormal) {
        return @"Standard";
    }
    if (mapType == kGMSTypeTerrain) {
        return @"Standard with Terrain";
    }
    if (mapType == kGMSTypeSatellite) {
        return @"Satellite";
    }
    return @"None";
}
@end
