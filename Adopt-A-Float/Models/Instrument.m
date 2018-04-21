//
//  Instrument.m
//  Adopt-A-Float
//
//  Created by Ben Leizman on 6/28/15.
//  Copyright © 2018 Frederik Simons. All rights reserved.
//

#import "Instrument.h"

@interface Instrument ()

@property (strong) NSString *name;
@property (strong) NSMutableArray<FloatData *> *floatData;

@end

@implementation Instrument

- (id)initWithName:(NSString *)name andfloatData:(NSMutableArray<FloatData *> *)floatData {
    self = [super init];
    if (self) {
        self.name = name;
        self.floatData = floatData; // Not defensively copied
    }
    return self;
}

- (FloatData *)getADataPoint {
    if (self.floatData.count > 0) {
        return self.floatData[0];
    }
    return NULL;
}

- (NSString *)getName {
    return self.name;
}

@end
