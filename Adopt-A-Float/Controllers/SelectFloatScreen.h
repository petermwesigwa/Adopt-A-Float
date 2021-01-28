//
//  SelectFloatScreen.h
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 1/26/21.
//  Copyright © 2021 Frederik Simons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppState.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectFloatScreen : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

NS_ASSUME_NONNULL_END
