//
//  mapIconView.m
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 7/29/19.
//  Copyright © 2019 Frederik Simons. All rights reserved.
//

#import "mapIconView.h"


@implementation mapIconView

// set
- (void)provideFloatData:(FloatData *)data {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    
    self.deviceName.text = (NSString*) data.deviceName;
    self.gpsDate.text = [formatter stringFromDate:(NSDate*)data.gpsDate];
    self.gpsLat.text = [data.gpsLat stringValue];
    self.gpsLon.text = [data.gpsLon stringValue];
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
