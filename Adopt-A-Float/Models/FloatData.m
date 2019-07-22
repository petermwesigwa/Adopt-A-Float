//
//  FloatData.m
//  Adopt-A-Float
//
//  Created by Ben Leizman on 10/10/15.
//  Copyright © 2018 Frederik Simons. All rights reserved.
//

#import "FloatData.h"

@interface FloatData ()

/* Column headers for data:
 %   Device name
 %   Matlab Date String
 %   Longitude
 %   Latitude
 %   Bunch of other random numbers
 
 %   (1:3) Date      1x3 double; [month day year]
 %   (4:7) time      1x4 double; [hour min sec tenthsec]
 %     (8) lat       Latitude (decimal degrees), north is positive
 %     (9) lon       Longitude (decimal degrees), east is positive
 %    (10) alt       Altitude (m)
 %    (11) vsp       Vertical speed (m/s)
 %    (12) vdop      Vertical dilution of precision
 %    (13) gsp       Ground speed (m/s)
 %    (14) hdop      Horizontal dilution of precision
 %    (15) crs       Course (decimal degrees)
 %    (16) sat       Number of satellites used
 %    (17) I         Indicator byte
 %    _____
 % (18:20) dopDate   1x3 double; [month day year]
 % (21:23) doptime   1x3 double; [hr min sec]
 %    (24) dopLat*   Doppler latitude
 %    (25) dopLon*   Doppler longitude
 %    (26) CEPrad*   Estimate of unit location accuracy (circle radius) in km
 */

/* Example of input:
 P017   19-Dec-2018 07:27:52   -10.781833  -137.062517   0.660
 1.380    14715  13936 79207   353   20     7   0   0
 */

//// Raw Data retrieved from online
//@property (strong) const NSString *deviceName;
//@property (strong) const NSDate *gpsDate;
//@property (strong) const NSNumber *gpsLat;                   //latitude
//@property (strong) const NSNumber *gpsLon;                   //longitude
//@property (strong) const NSNumber *alt;                      //altitude (m)
//@property (strong) const NSNumber *vsp;                      //vertical speed (m/s)
//@property (strong) const NSNumber *vdop;                     //vertical dilution of precision
//@property (strong) const NSNumber *gsp;                      //ground speed (m/s)
//@property (strong) const NSNumber *hdop;                     //horizontal dop

// Utility
@property (strong) NSCalendar *cal;

@end

@implementation FloatData

const int N_DATA_ELEMS = 10;

- (id)initWithRaw:(NSMutableArray<NSString *> *)orderedData {
    self = [super init];
    if (self && [FloatData isValidRaw:orderedData]) {
        //set calendar
        _cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        // read in the name of the instrument
        _deviceName = orderedData[0];
        
        // get the date at which the observation was made
        NSMutableString *dateString = [[NSMutableString alloc]initWithString:orderedData[1]];
        [dateString appendString:@" "];
        [dateString appendString:orderedData[2]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd-MMM-yyyy HH:mm:ss"];
    
        
        _gpsDate = [formatter dateFromString:dateString];
        _gpsLat = [NSNumber numberWithFloat:[orderedData[3] floatValue]];
        _gpsLon = [NSNumber numberWithFloat:[orderedData[4] floatValue]];
        _vdop = [NSNumber numberWithFloat:[orderedData[5] floatValue]];
        _hdop = [NSNumber numberWithFloat:[orderedData[6] floatValue]];
        _vbat = [NSNumber numberWithFloat:[orderedData[7] floatValue]];
        _int_pressure = [NSNumber numberWithFloat:[orderedData[8] floatValue]];
        _ext_pressure = [NSNumber numberWithFloat:[orderedData[9] floatValue]];
    }
    return self;
}

+ (BOOL)isValidRaw:(NSMutableArray<NSString *> *)raw {
    // TODO
    if (raw.count < N_DATA_ELEMS) {
        return NO;
    }
    return YES;
}

@end
