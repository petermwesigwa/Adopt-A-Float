//
//  Instrument.m
//  Adopt-A-Float
//
//  Created by Ben Leizman on 6/28/15.
//  Copyright © 2018 Frederik Simons. All rights reserved.
//

#import "Instrument.h"

@implementation Instrument

- (id)init
{
    self = [super init];
    return self;
}

- (id)initWithName:(NSString*) name andfloatData:(NSMutableArray *)floatData {
    self = [super init];
    self.name = name;
    self.floatData = floatData;
    return self;
}

@end
