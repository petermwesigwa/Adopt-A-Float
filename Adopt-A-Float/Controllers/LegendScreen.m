//
//  LegendScreen.m
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 1/8/21.
//  Copyright © 2021 Frederik Simons. All rights reserved.
//

#import "LegendScreen.h"
/*
 This is an effort to maintain state in one place that is accessible throughout the application.
 
 */
extern AppState *appStateManager;
extern NSMutableDictionary<NSString *, UIColor *> *organizations;

@interface LegendScreen ()
    @property(strong) NSArray<NSString *> *organizationNames;
@end

@implementation LegendScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _organizationNames = [organizations allKeys];
    _contentView.layer.cornerRadius = 6;
    _hideLegendButton.layer.cornerRadius = 20;
    _contentView.layer.masksToBounds = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)dismissModal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _organizationNames.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LegendCell"];
    NSString *orgName = [_organizationNames objectAtIndex:indexPath.row];
    UIColor *imgColor = [organizations objectForKey:orgName];
    cell.textLabel.text = orgName;
    if (![appStateManager.orgFilters objectForKey:orgName]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    cell.imageView.image = [GMSMarker markerImageWithColor: imgColor];
    return cell;
}

#pragma mark - UITableViewDelegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *orgName = cell.textLabel.text;
    if ([appStateManager.orgFilters objectForKey:orgName]) {
        [appStateManager.orgFilters removeObjectForKey:orgName];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        [appStateManager.orgFilters setValue:[NSNumber numberWithBool:NO] forKey:orgName];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

@end
