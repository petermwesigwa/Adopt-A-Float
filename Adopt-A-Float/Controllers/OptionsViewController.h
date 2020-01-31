//
//  OptionsViewController.h
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 8/26/19.
//  Copyright © 2019 Frederik Simons. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OptionsViewController : UITableViewController

@property (strong) NSString *currentInstrument; // current instrument on display
@property (strong) NSMutableArray<NSString*>* instruments;
@property (assign) int currentFloatNameIndex;
@property (assign) NSInteger *currentMarkerNumberIndex;
@property (assign) int markerNumber;

@property (weak, nonatomic) IBOutlet UILabel *currentInstrumentLabel;
@property (weak, nonatomic) IBOutlet UILabel *markerNumberLabel;
@end

NS_ASSUME_NONNULL_END
