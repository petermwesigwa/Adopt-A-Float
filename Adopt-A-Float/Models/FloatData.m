//
//  FloatData.m
//  Adopt-A-Float
//
//  Created by Ben Leizman on 10/10/15.
//  Modified by Peter Mwesigwa on 8/18/20
//  Copyright © 2018 Frederik Simons. All rights reserved.
//

#import "FloatData.h"

@interface FloatData ()

/* Example of input:
 Device Name: P017
 Date :       19-Dec-2018 07:27:52
 Latitude:    -10.781833
 Longitude:   -137.062517
 altitude:     0.660
 1.380    14715  13936 79207   353   20     7   0   0
 */

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
        _hdop = [NSNumber numberWithFloat:[orderedData[5] floatValue]];
        _vdop = [NSNumber numberWithFloat:[orderedData[6] floatValue]];
        _vbat = [NSNumber numberWithFloat:[orderedData[7] floatValue]];
        _pInt = [NSNumber numberWithFloat:[orderedData[8] floatValue]];
        _pExt = [NSNumber numberWithFloat:[orderedData[9] floatValue]];
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
