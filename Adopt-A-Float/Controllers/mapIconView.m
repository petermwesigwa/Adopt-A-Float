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
    [formatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];

    
    NSString *latFormat = @"";
    NSString *lonFormat = @"";
    if ([data.gpsLat doubleValue] > 0) {
        latFormat = @"%.2f \u00B0N";
    } else {
        latFormat = @"%.2f \u00B0S";
    }
    
    if ([data.gpsLon doubleValue] > 0) {
        lonFormat = @"%.2f \u00B0E";
    } else {
        lonFormat = @"%.2f \u00B0W";
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
    self.legLength.text = [NSString stringWithFormat:@"%.3f km",data.legLength];
    self.legTime.text = [NSString stringWithFormat:@"%.3f h",data.legTime];
    self.legSpeed.text = [NSString stringWithFormat:@"%.3f km",data.legSpeed];
    self.totalDist.text = [NSString stringWithFormat:@"%.3f km",data.totalDistance];
    self.totalTime.text = [NSString stringWithFormat:@"%.3f h",data.totalTime];
    self.avgSpeed.text = [NSString stringWithFormat:@"%.3f km",data.avgSpeed];
    self.WMSDepth.text = [NSString stringWithFormat:@"%.1f km", data.gebcoDepth];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
