//
//  LegendScreen.m
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 1/8/21.
//  Copyright © 2021 Frederik Simons. All rights reserved.
//

#import "LegendScreen.h"

extern NSMutableDictionary<NSString *, UIColor *> *organizations;

@interface LegendScreen ()
    @property(strong) NSArray<NSString *> *organizationNames;
@end

@implementation LegendScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _organizationNames = [organizations allKeys];
    _contentView.layer.cornerRadius = 5;
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

#pragma mark - UITableViewSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _organizationNames.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LegendCell"];
    NSString *cellLabel = [_organizationNames objectAtIndex:indexPath.row];
    UIColor *imgColor = [organizations objectForKey:cellLabel];
    cell.textLabel.text = cellLabel;
    cell.imageView.image = [GMSMarker markerImageWithColor: imgColor];
    return cell;
}
@end
