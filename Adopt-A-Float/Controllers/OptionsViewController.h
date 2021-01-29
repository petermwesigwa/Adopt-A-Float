//
//  OptionsViewController.h
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 8/26/19.
//  Copyright © 2019 Frederik Simons. All rights reserved.
//

/*
 This is the controller for the Options Screen navigated to from the map
 Inherits from UITableViewController
 */
#import <UIKit/UIKit.h>
#import "AppState.h"

NS_ASSUME_NONNULL_BEGIN

@interface OptionsViewController : UITableViewController

/* shows map type used in the MainViewController GMSMapView. */
@property (weak, nonatomic) IBOutlet UILabel *mapTypeLabel;

/* supposed to be an option to settle if the user wants their location shown or not */
@property (weak, nonatomic) IBOutlet UISwitch *showPlaces; // currently deprecated


@end

NS_ASSUME_NONNULL_END
