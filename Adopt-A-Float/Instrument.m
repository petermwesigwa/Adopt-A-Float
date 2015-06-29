//
//  Instrument.m
//  Adopt-A-Float
//
//  Created by Ben Leizman on 6/28/15.
//  Copyright (c) 2015 Son-O-Mermaid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Instrument.h"

@implementation Instrument

- (id)init
{
    self = [super init];
    return self;
}

- (id)initWithName:(NSString*) name andLat:(NSArray*) lat andLon:(NSArray*) lon
{
    self = [super init];
    self.name = name;
    self.lat = [[NSMutableArray alloc] init];
    self.lon = [[NSMutableArray alloc] init];
    [self.lat addObjectsFromArray:lat];
    [self.lon addObjectsFromArray:lon];
    return self;
}

@end
