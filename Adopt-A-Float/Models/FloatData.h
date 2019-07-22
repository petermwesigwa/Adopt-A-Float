//
//  FloatData.h
//  Adopt-A-Float
//
//  Created by Ben Leizman on 10/10/15.
//  Copyright © 2018 Frederik Simons. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FloatData : NSObject

@property (strong, readonly) const NSString *deviceName;               //name of the instrument
@property (strong, readonly) const NSDate *gpsDate;                    //date reported by instrument
@property (strong, readonly) const NSNumber *gpsLat;                   //latitude
@property (strong, readonly) const NSNumber *gpsLon;                   //longitude
@property (strong, readonly) const NSNumber *vdop;                     //vertical dilution of precision
@property (strong, readonly) const NSNumber *hdop;                     //horizontal dilution of precision
@property (strong, readonly) const NSNumber *vbat;                     //battery voltage remaining
@property (strong, readonly) const NSNumber *int_pressure;             //Internal pressure
@property (strong, readonly) const NSNumber *ext_pressure;             //External pressure

// Returns a new FloatData object or NULL if orderedData is invalid
- (id)initWithRaw:(NSMutableArray<NSString *> *)orderedData;

// Returns YES if the rawData is in a valid format
+ (BOOL)isValidRaw:(NSMutableArray<NSString *> *)rawData;

@end
