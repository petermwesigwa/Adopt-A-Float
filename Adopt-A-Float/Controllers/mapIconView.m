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
    [data updateWithGebcoDepth];
    

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"d MMM yyyy HH:mm:ss"];
    
    self.deviceName.text = (NSString*) data.deviceName;
    self.gpsDate.text = [NSString stringWithFormat:@"%@ GMT",[formatter stringFromDate:(NSDate*)data.gpsDate]];
    self.gpsLat.text = [NSString stringWithFormat:@"%11.6f", [data.gpsLat floatValue]];
    self.gpsLon.text = [NSString stringWithFormat:@"%11.6f", [data.gpsLon floatValue]];
    self.hdop.text = [NSString stringWithFormat:@"%@", data.hdop];
    self.vdop.text = [NSString stringWithFormat:@"%@", data.vdop];
    self.vBat.text =[NSString stringWithFormat:@"%@ mV", data.vbat];
    self.pInt.text = [NSString stringWithFormat:@"%@ Pa", data.pInt];
    self.pExt.text = [NSString stringWithFormat:@"%@ mbar", data.pExt];
    self.legLength.text = [NSString stringWithFormat:@"%.3f km",data.legLength];
    self.legTime.text = [NSString stringWithFormat:@"%.3f h",data.legTime];
    self.legSpeed.text = [NSString stringWithFormat:@"%.3f km/h",data.legSpeed];
    self.totalDist.text = [NSString stringWithFormat:@"%.3f km",data.totalDistance];
    self.totalTime.text = [NSString stringWithFormat:@"%.3f h",data.totalTime];
    self.avgSpeed.text = [NSString stringWithFormat:@"%.3f km/h",data.avgSpeed];
    self.WMSDepth.text = [NSString stringWithFormat:@"%.1f m", data.gebcoDepth];

}

+ (NSString *) prettyPrintDegree:(float)deg whichIsLat:(BOOL)isLat {
    NSString *format;
    
    if (isLat && deg > 0) {
        format = @"%.6f \u00B0N";
    } else if (isLat) {
        format = @"%.6f \u00B0S";
    } else if (deg > 0) {
        format = @"%.6f \u00B0E";
    } else {
        format = @"%.6f \u00B0W";
    }
    return [NSString stringWithFormat:format, fabsf(deg)];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@end
