//
//  SelectMarkerNumberViewController.h
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 8/26/19.
//  Copyright © 2019 Frederik Simons. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectMarkerNumberViewController : UITableViewController
@property (strong) NSArray<NSString*> *options;
@property (strong) NSArray<NSNumber*> *counts;
@property (assign) int *selectedFloatIndex;
@property (assign) int *selectedMarkerNumber;

@end

NS_ASSUME_NONNULL_END
