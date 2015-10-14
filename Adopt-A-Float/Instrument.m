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

- (id)initWithName:(NSString*) name andfloatData:(NSMutableArray *)floatData {
    self = [super init];
    self.name = name;
    self.floatData = floatData;
    return self;
}

@end
