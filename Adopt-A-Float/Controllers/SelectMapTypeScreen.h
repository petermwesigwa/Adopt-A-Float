//
//  SelectMapTypeScreen.h
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 10/26/20.
//  Copyright © 2020 Frederik Simons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppState.h"
#import <GoogleMaps/GoogleMaps.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectMapTypeScreen : UITableViewController

 @property (strong) NSArray<NSNumber *> *mapTypes;
@end

NS_ASSUME_NONNULL_END
