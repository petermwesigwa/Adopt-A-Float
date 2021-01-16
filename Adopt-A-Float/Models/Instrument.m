//
//  Instrument.m
//  Adopt-A-Float
//
//  Created by Ben Leizman on 6/28/15.
//  Modified by Peter Mwesigwa on 8/18/20
//  Copyright © 2018 Frederik Simons. All rights reserved.
//

#import "Instrument.h"

@interface Instrument ()
    /* name of the instrument */
    @property (strong, readonly) NSString *name;

    /* Array of all readings by this instrument. Each reading is stored as a FloatData object. These readings should be arranged with the most recent coming first. */
    @property (strong, readonly) NSMutableArray<FloatData *> *floatData;

    /* Display color of instrument on map */
    @property (strong) UIColor *color;
    
    /* institution to which the float belongs */
    @property (strong) NSString *institution;

@end

@implementation Instrument

- (id)initWithName:(NSString *)name andfloatData:(NSMutableArray<FloatData *> *)floatData {
    self = [super init];
    if (self) {
        _name = name;
        _floatData = floatData;
    }
    [self assignColorAndInstitution];
    return self;
}
- (NSString *)getName {
    return self.name;
}

- (NSMutableArray<FloatData *> *)getFloatData {
    return self.floatData;
}

- (UIColor *)getColor {
    return self.color;
}

-(NSString *)getInstitution {
    return self.institution;
}
/* Assign an instrument its color based off of the organization it belongs to. We can deduce the organization from the instrument's name*/
-(void)assignColorAndInstitution {
    int float_id = [[self.name substringFromIndex:1] intValue];
    if (float_id == 6) { // GeoAzur
        self.color = [UIColor blueColor];
        self.institution = @"GeoAzur";
    }
    else if (float_id == 3 || float_id == 7) { // Dead
        //return [UIColor grayColor];
        self.color = [UIColor grayColor];
        self.institution = @"Inactive";
    }
    else if (float_id > 26 && float_id < 49) { // SUSTech
        //return [UIColor yellowColor];
        self.color = [UIColor yellowColor];
        self.institution = @"SUSTech";
    }
    else if ([_name hasPrefix:@"P"]) { // Princeton
        //return [UIColor orangeColor];
        self.color = [UIColor orangeColor];
        self.institution = @"Princeton";
    }
    else {
        self.color = [UIColor redColor];
        self.institution = @"JAMSTEC";
    }
    //return [UIColor redColor]; // JAMSTEC
}

@end
