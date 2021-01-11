//
//  LegendScreen.h
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 1/8/21.
//  Copyright © 2021 Frederik Simons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "AppState.h"

NS_ASSUME_NONNULL_BEGIN

@interface LegendScreen : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
- (IBAction)dismissModal:(id)sender;

@end

NS_ASSUME_NONNULL_END
