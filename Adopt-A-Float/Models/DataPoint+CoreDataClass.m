//
//  DataPoint+CoreDataClass.m
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 2/6/21.
//  Copyright © 2021 Frederik Simons. All rights reserved.
//
//

#import "DataPoint+CoreDataClass.h"

// degree to radian conversion
float const HAVERSINE_RADS_PER_DEGREE = M_PI / 180.0;

// radius of the earth in km
float const HAVERSINE_KM_RADIUS = 6378.137;

// number of columns of observation that each float records
// for now this number is 10 but Frederik might change it in the future
const int N_DATA_COLUMNS = 10;

/*  minimum time in hours that a float is expected to spend underwater between surfacings. Can be safely assumed that any consecutive points within this time of each other are within the same surfacing, and can be applied transitively for other
    floats.
 
    This is used to filter between surface drift and subsurface drift. Any points that
    are within this threshold from the preceding float are not used in leg calculations
    and merely carry on results for.
 
    Setting it to zero uses ALL points for leg calculations.
 */
double const MIN_TIME_BETWEEN_SURFACINGS = 0.0;
@interface DataPoint()
@end
@implementation DataPoint
- (void) addDataFromRaw:(NSArray<NSString*>*)rawData {
   
    self.deviceName = [DataPoint standardizeName:rawData[0]];
   
    NSString *dateString = [NSString stringWithFormat:@"%@ %@", rawData[1], rawData[2]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd-MMM-yyyy HH:mm:ss"];
    self.gpsDate = [formatter dateFromString:dateString];
   
    self.gpsLat = [rawData[3] doubleValue];
    self.gpsLon = [rawData[4] doubleValue];
    self.hDop = [rawData[5] doubleValue];
    self.vDop = [rawData[6] doubleValue];
    self.vBat = [rawData[7] doubleValue];
   // ignore column 8 for now
    self.intPressure = [rawData[9] doubleValue];
    self.extPressure = [rawData[10] doubleValue];
    self.legLength = 0;
    self.legTime = 0;
    self.legSpeed = 0;
    self.totalDistance = 0;
    self.totalTime = 0;
    self.avgSpeed = 0;
    self.netDisplacement = 0;
}

+ (BOOL) isValidRaw:(NSArray<NSString*>*)rawData {
    if (rawData.count < N_DATA_COLUMNS) {
        return NO;
    }
    
    for (NSString *field in rawData) {
        if ([[field uppercaseString] isEqualToString:@"NAN"]) {
            return NO;
        }
    }
    return YES;
}

+ (NSString*)standardizeName:(NSString*)floatName {
    if ([floatName length] == 4) {
           return floatName;
       }
    return [floatName stringByReplacingOccurrencesOfString:@"00" withString:@"0"];
}

- (void) matchWithInstrument:(Instrument *)instrument {
    self.instrument = instrument;
}
- (void) save {
    NSError *error = nil;
    if ([[self managedObjectContext] save:&error] == NO) {
        NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
    }
}


- (BOOL) isEqualToDataPoint:(DataPoint *)that {
    BOOL forSameDevice = [self.deviceName isEqualToString:that.deviceName];
    BOOL datesAreEqual = [self.gpsDate isEqualToDate:that.gpsDate];
    return forSameDevice && datesAreEqual;
}
- (void)addLegDataUsingPreviousPoint:(DataPoint *)prevPoint andFirstPoint:(DataPoint *)firstPoint {
    double legTime = [self durationBetween:prevPoint];
    double legLength = [self distanceFrom:prevPoint];
    
    // only update if not part of same surfacing
    if (legTime > MIN_TIME_BETWEEN_SURFACINGS) {
        self.legLength = legLength;
        self.legTime = legTime;
        self.legSpeed = legLength / legTime;
        self.totalDistance = legLength + prevPoint.totalDistance;
        self.totalTime = legTime + prevPoint.totalTime;
        self.avgSpeed = self.totalDistance / self.totalTime;
        self.netDisplacement = [self distanceFrom:firstPoint];
    } else {
        self.legLength = prevPoint.legLength;
        self.legTime = prevPoint.legTime;
        self.legSpeed = prevPoint.legSpeed;
        self.totalDistance = prevPoint.totalDistance;
        self.totalTime = prevPoint.totalTime;
        self.avgSpeed = prevPoint.avgSpeed;
        self.netDisplacement = [self distanceFrom:firstPoint];
    }
}

// compute haversine distance to another float
- (double) distanceFrom:(DataPoint *)that {
    double lat1 = self.gpsLat * HAVERSINE_RADS_PER_DEGREE;
    double lon1 = self.gpsLon * HAVERSINE_RADS_PER_DEGREE;
    double lat2 = that.gpsLat * HAVERSINE_RADS_PER_DEGREE;
    double lon2 = that.gpsLon * HAVERSINE_RADS_PER_DEGREE;
    double havLatDiff = 0.5 - 0.5 * cos(lat2 - lat1);
    double havLonDiff = 0.5 - 0.5 * cos(lon2 - lon1);
    double haversine = havLatDiff + cos(lat1) * cos(lat2) * havLonDiff;
    double centralAngle = 2 * atan2(sqrt(haversine), sqrt(1-haversine));
    return centralAngle * HAVERSINE_KM_RADIUS;
}

// time difference in hours to another float
- (double) durationBetween:(DataPoint *)that {
    double time1 = (double) [self.gpsDate timeIntervalSince1970];
    double time2 = (double) [that.gpsDate timeIntervalSince1970];
    return fabs(time1 - time2) / 3600.0;
}
@end
