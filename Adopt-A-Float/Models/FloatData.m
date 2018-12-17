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
 5  22 2015  15  37  13   0  32.3702167 -64.6956000     20.25300     -0.02000  1.40     \
 0.00000  0.85   0.00   9   4   5  22 2015  15  37  26  32.36812 -64.72869   6
 */

// Raw Data retrieved from online
@property (strong) const NSDate *gpsDate;
@property (strong) const NSDateComponents *gpsComponents;
@property (strong) const NSNumber *gpsLat;                   //latitude
@property (strong) const NSNumber *gpsLon;                   //longitude
@property (strong) const NSNumber *alt;                      //altitude (m)
@property (strong) const NSNumber *vsp;                      //vertical speed (m/s)
@property (strong) const NSNumber *vdop;                     //vertical dilution of precision
@property (strong) const NSNumber *gsp;                      //ground speed (m/s)
@property (strong) const NSNumber *hdop;                     //horizontal dop
@property (strong) const NSNumber *crs;                      //course
@property (strong) const NSNumber *sat;                      //Number of satelites used
@property (strong) const NSNumber *iByte;                    //Indicator byte
@property (strong) const NSDate *dopDate;                    // date from doppler
@property (strong) const NSDateComponents *dopComponents;
@property (strong) const NSNumber *dopLat;
@property (strong) const NSNumber *dopLon;
@property (strong) const NSNumber *CEPrad;                   //Estimate of unit location accuracy (circle radius) in km

// Utility
@property (strong) NSCalendar *cal;

@end

@implementation FloatData

const int N_DATA_ELEMS = 26;

- (id)initWithRaw:(NSMutableArray<NSString *> *)orderedData {
    self = [super init];
    if (self && [FloatData isValidRaw:orderedData]) {
        //set calendar
        _cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; 
        
        // GPS variables
        _gpsComponents = [[NSDateComponents alloc] init];
        [_gpsComponents setMonth:(NSInteger)orderedData[0]];
        [_gpsComponents setDay:(NSInteger)orderedData[1]];
        [_gpsComponents setYear:(NSInteger)orderedData[2]];
        [_gpsComponents setHour:(NSInteger)orderedData[3]];
        [_gpsComponents setMinute:(NSInteger)orderedData[4]];
        [_gpsComponents setSecond:(NSInteger)orderedData[5]];
        [_gpsComponents setNanosecond:(NSInteger)(orderedData[6])*10^-8];
        _gpsDate = [_cal dateFromComponents: (NSDateComponents *) _gpsComponents];
        _gpsLat = [NSNumber numberWithFloat:[orderedData[7] floatValue]];
        _gpsLon = [NSNumber numberWithFloat:[orderedData[8] floatValue]];
        _alt = [NSNumber numberWithFloat:[orderedData[9] floatValue]];
        _vsp = [NSNumber numberWithFloat:[orderedData[10] floatValue]];
        _vdop = [NSNumber numberWithFloat:[orderedData[11] floatValue]];
        _gsp = [NSNumber numberWithFloat:[orderedData[12] floatValue]];
        _hdop = [NSNumber numberWithFloat:[orderedData[13] floatValue]];
        _crs = [NSNumber numberWithFloat:[orderedData[14] floatValue]];
        _sat = [NSNumber numberWithInteger:[orderedData[15] integerValue]];
        _iByte = [NSNumber numberWithInteger:[orderedData[16] integerValue]];
        
        // Doppler variables
        _dopComponents = [[NSDateComponents alloc] init];
        [_dopComponents setMonth:(NSInteger)orderedData[17]];
        [_dopComponents setDay:(NSInteger)orderedData[18]];
        [_dopComponents setYear:(NSInteger)orderedData[19]];
        [_dopComponents setHour:(NSInteger)orderedData[20]];
        [_dopComponents setMinute:(NSInteger)orderedData[21]];
        [_dopComponents setSecond:(NSInteger)orderedData[22]];
        _dopDate = [_cal dateFromComponents: (NSDateComponents *) _dopComponents];
        _dopLat = [NSNumber numberWithFloat:[orderedData[23] floatValue]];
        _dopLon = [NSNumber numberWithFloat:[orderedData[24] floatValue]];
        _CEPrad = [NSNumber numberWithFloat:[orderedData[25] floatValue]];
    }
    return self;
}

+ (BOOL)isValidRaw:(NSMutableArray<NSString *> *)raw {
    // Check array length
    if (raw.count != N_DATA_ELEMS)
        return NO;
    // TODO
    return YES;
}

@end
