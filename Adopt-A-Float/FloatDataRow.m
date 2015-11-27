//
//  FloatDataRow.m
//  Adopt-A-Float
//
//  Created by Ben Leizman on 10/10/15.
//  Copyright © 2015 Son-O-Mermaid. All rights reserved.
//

#import "FloatDataRow.h"

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

/*  
 Example of input:
 
 5  22 2015  15  37  13   0  32.3702167 -64.6956000     20.25300     -0.02000  1.40     0.00000  0.85   0.00   9   4   5  22 2015  15  37  26  32.36812 -64.72869   6
 */

@implementation FloatDataRow

-(id) initWithMutArr:(NSMutableArray*) raw {
    
    self = [super init];
    //GPS variables
    _gpsComponents = [[NSDateComponents alloc] init];
    [_gpsComponents setMonth:(NSInteger)raw[0]];
    [_gpsComponents setDay:(NSInteger)raw[1]];
    [_gpsComponents setYear:(NSInteger)raw[2]];
    [_gpsComponents setHour:(NSInteger)raw[3]];
    [_gpsComponents setMinute:(NSInteger)raw[4]];
    [_gpsComponents setSecond:(NSInteger)raw[5]];
    [_gpsComponents setNanosecond:(NSInteger)(raw[6])*10^-8];
    _gpsDate = [cal dateFromComponents:_gpsComponents];
    _gpsLat = [NSNumber numberWithFloat:[raw[7] floatValue]];
    _gpsLon = [NSNumber numberWithFloat:[raw[8] floatValue]];
    _alt = [NSNumber numberWithFloat:[raw[9] floatValue]];
    _vsp = [NSNumber numberWithFloat:[raw[10] floatValue]];
    _vdop = [NSNumber numberWithFloat:[raw[11] floatValue]];
    _gsp = [NSNumber numberWithFloat:[raw[12] floatValue]];
    _hdop = [NSNumber numberWithFloat:[raw[13] floatValue]];
    _crs = [NSNumber numberWithFloat:[raw[14] floatValue]];
    _sat = [NSNumber numberWithInteger:[raw[15] integerValue]];
    _iByte = [NSNumber numberWithInteger:[raw[16] integerValue]];
    
    //Doppler variables
    _dopComponents = [[NSDateComponents alloc] init];
    [_dopComponents setMonth:(NSInteger)raw[17]];
    [_dopComponents setDay:(NSInteger)raw[18]];
    [_dopComponents setYear:(NSInteger)raw[19]];
    [_dopComponents setHour:(NSInteger)raw[20]];
    [_dopComponents setMinute:(NSInteger)raw[21]];
    [_dopComponents setSecond:(NSInteger)raw[22]];
    _dopDate = [cal dateFromComponents:_dopComponents];
    _dopLat = [NSNumber numberWithFloat:[raw[23] floatValue]];
    _dopLon = [NSNumber numberWithFloat:[raw[24] floatValue]];
    _CEPrad = [NSNumber numberWithFloat:[raw[25] floatValue]];
    
    return self;
    
}

@end
