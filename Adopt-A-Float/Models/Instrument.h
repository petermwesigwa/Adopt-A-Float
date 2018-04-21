//
//  Instrument.h
//  Adopt-A-Float
//
//  Created by Ben Leizman on 6/28/15.
//  Copyright © 2018 Frederik Simons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FloatData.h"

@interface Instrument : NSObject

@property (strong, readonly) NSString *name;
@property (strong, readonly) NSMutableArray<FloatData *> *floatData;

// Create a new instrument
- (id)initWithName:(NSString *)name andfloatData:(NSMutableArray<FloatData *> *)floatData;

// Return a data point
- (FloatData *)getADataPoint;

@end
