//
//  mapIconView.m
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 7/29/19.
//  Copyright © 2019 Frederik Simons. All rights reserved.
//

// Implementation ofm mapiconView.h
#import "mapIconView.h"


@implementation mapIconView


- (void)provideFloatData:(FloatData *)data {
    // set up formatter to read in date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    
    NSString *latFormat = @"";
    NSString *lonFormat = @"";
    if ([data.gpsLat doubleValue] > 0) {
        latFormat = @"%.2f N";
    } else {
        latFormat = @"%.2f S";
    }
    
    if ([data.gpsLon doubleValue] > 0) {
        lonFormat = @"%.2f E";
    } else {
        lonFormat = @"%.2f W";
    }
    // populate each of the UIlabels for the view with information from the FloatData object
    // with the measurement
    self.deviceName.text = (NSString*) data.deviceName;
    self.gpsDate.text = [formatter stringFromDate:(NSDate*)data.gpsDate];
    self.gpsLat.text = [NSString stringWithFormat:
                        latFormat,fabsf([data.gpsLat floatValue])];
    self.gpsLon.text = [NSString stringWithFormat:
                        lonFormat, fabsf([data.gpsLon floatValue])];
    self.hdop.text = [NSString stringWithFormat:@"%@ m", data.hdop];
    self.vdop.text = [NSString stringWithFormat:@"%@ m", data.vdop];
    self.vBat.text =[NSString stringWithFormat:@"%@ mV", data.vbat];
    self.pInt.text = [NSString stringWithFormat:@"%@ Pa", data.pInt];
    self.pExt.text = [NSString stringWithFormat:@"%@ mbar", data.pExt];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
