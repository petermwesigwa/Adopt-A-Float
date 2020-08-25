//
//  Instrument.h
//  Adopt-A-Float
//
//  Created by Ben Leizman on 6/28/15.
//  Modified by Peter Mwesigwa on 8/18/20
//  Copyright © 2018 Frederik Simons. All rights reserved.

/*
    This class represents a single mermaid instrument along with all its recorded readings.
    Each instrument is assigned a display color on the map to show which organization
    it belongs to.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FloatData.h"

@interface Instrument : NSObject

@property (strong, readonly) NSString *name; // name of the mermaid

// array of all the readings recorded by this mermaid
@property (strong, readonly) NSMutableArray<FloatData *> *floatData;

// display color of mermaid on map
@property (strong, readonly) UIColor *color;

// Create a new instrument
- (id)initWithName:(NSString *)name andfloatData:(NSMutableArray<FloatData *> *)floatData;

// Return a data point
- (FloatData *)getADataPoint;

// get color assigned to instrument
- (UIColor *)getColor;

// This assigns instruments its color
+ (UIColor *)assignColor: (NSString *)floatName;

@end
