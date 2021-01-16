//
//  Instrument.m
//  Adopt-A-Float
//
//  Created by Ben Leizman on 6/28/15.
//  Modified by Peter Mwesigwa on 8/18/20
//  Copyright © 2018 Frederik Simons. All rights reserved.
//

#import "Instrument.h"

extern NSMutableDictionary<NSString *, UIColor *> *organizations;

@interface Instrument ()
    /* name of the instrument */
    @property (strong, readonly) NSString *name;

    /* Array of all readings by this instrument. Each reading is stored as a FloatData object. These readings should be arranged with the most recent coming first. */
    @property (strong, readonly) NSArray<FloatData *> *floatData;

    @property (strong, readonly) NSArray<NSArray<NSString*>*> *rawData;

    /* institution to which the float belongs */
    @property (strong, readonly) NSString *institution;

@end

@implementation Instrument

- (id)initWithName:(NSString *)name andData:(NSArray<NSArray<NSString*>*> *)data {
    self = [super init];
    if (self) {
        _name = name;
        _floatData = [Instrument generateFloatData:data];
        _institution = [Instrument assignInstitution:name];
        _rawData = data;
    }
    return self;
}

- (NSString *)getName {
    return self.name;
}

- (NSArray<FloatData *> *)getFloatData {
    return self.floatData;
}

- (UIColor *)getColor {
    return [organizations objectForKey:_institution];
}

- (NSString *)getInstitution {
    return self.institution;
}
- (NSArray<NSArray<NSString *> *> *)getRaw {
    return self.rawData;
}
/* Assign an instrument its color based off of the organization it belongs to. We can deduce the organization from the instrument's name*/
+ (NSString *) assignInstitution:(NSString *)instrumentName {
    int float_id = [[instrumentName substringFromIndex:1] intValue];
    if (float_id == 6) { // GeoAzur
        return @"GeoAzur";
    }
    if (float_id == 3 || float_id == 7) { // Dead
        //return [UIColor grayColor];
        return @"Inactive";
    }
    if (float_id > 26 && float_id < 49) { // SUSTech
        //return [UIColor yellowColor];
        return @"SUSTech";
    }
    if ([instrumentName hasPrefix:@"P"]) { // Princeton
        //return [UIColor orangeColor];
        return @"Princeton";
    }
    //return [UIColor redColor]; // JAMSTEC
    return @"JAMSTEC";
}

+ (NSArray<FloatData *> *) generateFloatData:(NSArray<NSArray<NSString *> *> *)data {
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (NSArray<NSString *> *dataRow in data) {
        FloatData *floatData = [[FloatData alloc] initWithRaw:dataRow];
        [dataArray addObject:floatData];
    }
    
    // add leg information
    // compute leg length, time, speed, totaldistance, totaltime, totalspeed.
    for (int i= (int) dataArray.count - 2;i >= 0;i--) {
        [dataArray[i] updateLegDataUsingPreviousFloat:dataArray[i+1]
                                      andFirstFloat:dataArray[dataArray.count-1]];
    }
    return dataArray;
}
@end
