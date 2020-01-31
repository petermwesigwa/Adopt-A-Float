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
        _color = [Instrument assignColor:name];

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

+ (UIColor *)assignColor:(NSString*)floatName {
    int float_id = [[floatName substringFromIndex:1] intValue];
    if (float_id == 6) {
        return [UIColor blueColor];
    }
    if (float_id == 3 || float_id == 7) {
        return [UIColor grayColor];
    }
    if (float_id > 26 && float_id < 49) {
        return [UIColor yellowColor];
    }
    if ([floatName hasPrefix:@"P"]) {
        return [UIColor orangeColor];
    }
    return [UIColor redColor];
}

- (UIColor *)getColor {
    return self.color;
}

@end
