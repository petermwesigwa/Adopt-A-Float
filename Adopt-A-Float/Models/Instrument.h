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
/* Create an instrument by passing in its name and an array of FloatData objects for each of its readings */

- (id)initWithName:(NSString *)name andData:(NSArray<NSArray<NSString*>*> *)data;
/* retrieve the name of the instrument */
- (NSString *)getName;

- (NSArray<FloatData *> *)getFloatData;

/* retrieve the color of the instrument for display on the map */
- (UIColor *)getColor;

/* retrieve the institution by which the float was deployed*/
- (NSString *)getInstitution;

- (NSArray<NSArray<NSString*>*>*) getRaw;
@end
