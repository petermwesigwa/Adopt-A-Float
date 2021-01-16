//
//  SelectFloatTableViewController.h
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 8/26/19.
//  Copyright © 2019 Frederik Simons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppState.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectFloatTableViewController : UITableViewController

// lost of all the instrument names
@property (strong) NSMutableArray<NSString*> *instruments;

// name of the currently selected instrument
@property (strong) NSString *selectedFloat;

// index to locate selected instrument within array
@property (assign) int selectedFloatIndex;


@end

NS_ASSUME_NONNULL_END
