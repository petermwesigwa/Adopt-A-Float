//
//  mapIconView.h
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 7/29/19.
//  Copyright © 2019 Frederik Simons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Models/FloatData.h"

NS_ASSUME_NONNULL_BEGIN

@interface mapIconView : UIView

@property (weak, nonatomic) IBOutlet UILabel *deviceName;  // name of the device
@property (weak, nonatomic) IBOutlet UILabel *gpsLat;  // latitude reported
@property (weak, nonatomic) IBOutlet UILabel *gpsLon;  // longitude reported
@property (weak, nonatomic) IBOutlet UILabel *hdop;    // horizontal dilution of precision
@property (weak, nonatomic) IBOutlet UILabel *vdop;    // vertical dilution of precision
@property (weak, nonatomic) IBOutlet UILabel *vBat;    // device battery in mv
@property (weak, nonatomic) IBOutlet UILabel *pInt;    // internal pressure
@property (weak, nonatomic) IBOutlet UILabel *pExt;    // external pressure
@property (weak, nonatomic) IBOutlet UILabel *gpsDate; // date of report

// initialize the view with data from a specific observation for a float.
- (void) provideFloatData:(FloatData*)data;

@end

NS_ASSUME_NONNULL_END
