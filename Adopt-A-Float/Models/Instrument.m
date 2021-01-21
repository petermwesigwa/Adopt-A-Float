//
//  Instrument.m
//  Adopt-A-Float
//
//  Created by Ben Leizman on 6/28/15.
//  Modified by Peter Mwesigwa on 8/18/20
//  Copyright © 2018 Frederik Simons. All rights reserved.
//

#import "Instrument.h"

extern NSMutableDictionary<NSString *, UIColor*> *organizations;

@interface Instrument ()
    /* name of the instrument */
    @property (strong, readonly) NSString *name;

    /* Array of all readings by this instrument. Each reading is stored as a FloatData object. These readings should be arranged with the most recent coming first. */
    @property (strong, readonly) NSArray<FloatData *> *floatData;

    /* Display color of instrument on map */
    @property (strong, readonly) NSArray<NSArray<NSString *> *> *rawData;
    
    /* institution to which the float belongs */
    @property (strong, readonly) NSString *institution;

@end

@implementation Instrument

- (id) initWithName:(NSString *)name andData:(NSArray<NSArray<NSString *> *> *)parsedData {
    self = [super init];
    if (self) {
        _name = name;
        _floatData = [Instrument storeFloatData:parsedData];
        _rawData = parsedData;
        _institution = [Instrument assignInstitutionFor:name];
    }
    return self;
}

- (NSString *)getName {
    return self.name;
}

- (NSArray<FloatData *> *)getFloatData {
    return self.floatData;
}

- (NSArray<NSArray<NSString *> *> *)getRawData {
    return self.rawData;
}

- (UIColor *)getColor {
    return organizations[self.institution];
}

-(NSString *)getInstitution {
    return self.institution;
}
/* Assign an instrument its color based off of the organization it belongs to. We can deduce the organization from the instrument's name*/
+ (NSString *)assignInstitutionFor:(NSString *)instrName {
    int float_id = [[instrName substringFromIndex:1] intValue];
    if (float_id == 6) { // GeoAzur
       return @"GeoAzur";
    }
    else if (float_id == 3 || float_id == 7) { // Dead
        //return [UIColor grayColor];
        return @"Inactive";
    }
    else if (float_id > 26 && float_id < 49) { // SUSTech
        //return [UIColor yellowColor];
       return @"SUSTech";
    }
    else if ([instrName hasPrefix:@"P"]) { // Princeton
        //return [UIColor orangeColor];
        return @"Princeton";
    }
    else {
        return @"JAMSTEC";
    }
    //return [UIColor redColor]; // JAMSTEC
}

+ (NSArray<FloatData *> *) storeFloatData:(NSArray<NSArray<NSString *> *> *)inputData {
    NSMutableArray<FloatData *> *data = [NSMutableArray new];
    for (NSArray<NSString*>*row in inputData) {
        if ([FloatData isValidRaw:row]) {
            FloatData *dataRow = [[FloatData alloc] initWithRaw:row];
            [data addObject:dataRow];
        }
    }
    
    for (int i = (int) data.count - 2; i >= 0; i--) {
        [data[i] updateLegDataUsingPreviousFloat:data[i+1] andFirstFloat:[data lastObject]];
    }
    
    return data;
}

@end
