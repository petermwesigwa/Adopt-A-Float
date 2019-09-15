//
//  SelectFloatTableViewController.h
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 8/26/19.
//  Copyright © 2019 Frederik Simons. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectFloatTableViewController : UITableViewController

@property (strong) NSMutableArray<NSString*> *instruments;
@property (strong) NSString *selectedFloat;
@property (assign) int selectedFloatIndex;

@end

NS_ASSUME_NONNULL_END
