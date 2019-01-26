//
//  FloatData.h
//  Adopt-A-Float
//
//  Created by Ben Leizman on 10/10/15.
//  Copyright © 2018 Frederik Simons. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FloatData : NSObject

@property (strong, readonly) const NSString *deviceName;
@property (strong, readonly) const NSDate *gpsDate;
@property (strong, readonly) const NSDateComponents *gpsComponents;
@property (strong, readonly) const NSNumber *gpsLat;                   //latitude
@property (strong, readonly) const NSNumber *gpsLon;                   //longitude
@property (strong, readonly) const NSNumber *alt;                      //altitude (m)
@property (strong, readonly) const NSNumber *vsp;                      //vertical speed (m/s)
@property (strong, readonly) const NSNumber *vdop;                     //vertical dilution of precision
@property (strong, readonly) const NSNumber *gsp;                      //ground speed (m/s)
@property (strong, readonly) const NSNumber *hdop;                     //horizontal dop
@property (strong, readonly) const NSNumber *crs;                      //course
@property (strong, readonly) const NSNumber *sat;                      //Number of satelites used
@property (strong, readonly) const NSNumber *iByte;                    //Indicator byte
@property (strong, readonly) const NSDate *dopDate;                    // date from doppler
@property (strong, readonly) const NSDateComponents *dopComponents;
@property (strong, readonly) const NSNumber *dopLat;
@property (strong, readonly) const NSNumber *dopLon;
@property (strong, readonly) const NSNumber *CEPrad;                   //Estimate of unit location accuracy (circle radius) in km

// Returns a new FloatData object or NULL if orderedData is invalid
- (id)initWithRaw:(NSMutableArray<NSString *> *)orderedData;

// Returns YES if the rawData is in a valid format
+ (BOOL)isValidRaw:(NSMutableArray<NSString *> *)rawData;

@end
