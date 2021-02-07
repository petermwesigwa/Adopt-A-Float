//
//  DataPoint+CoreDataClass.m
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 2/6/21.
//  Copyright © 2021 Frederik Simons. All rights reserved.
//
//

#import "DataPoint+CoreDataClass.h"

const int N_DATA_COLUMNS = 10;
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
    self.instrument = instrument
}
- (void) save {
    NSError *error = nil;
    if ([[self managedObjectContext] save:&error] == NO) {
        NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
    }
}
@end
