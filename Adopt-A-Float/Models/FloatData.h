//
//  FloatData.h
//  Adopt-A-Float
//
//  Created by Ben Leizman on 10/10/15.
//  Modified by Peter Mwesigwa on 8/18/20
//  Copyright © 2018 Frederik Simons. All rights reserved.
//


/* This class represents all the measurements taken during a single reading by a mermaid
 
 
 Example of input:
 Device Name: P017
 Date :       19-Dec-2018 07:27:52
 Latitude:    -10.781833
 Longitude:   -137.062517
 altitude:     0.660
 1.380    14715  13936 79207   353   20     7   0   0
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FloatData : NSObject

@property (strong, readonly) const NSString *deviceName;                // name of the mermaid
@property (strong, readonly) const NSDate *gpsDate;                     // date of reading
@property (strong, readonly) const NSNumber *gpsLat;                   //latitude
@property (strong, readonly) const NSNumber *gpsLon;                   //longitude
@property (strong, readonly) const NSNumber *hdop;                      //horizontal dilution of precision
@property (strong, readonly) const NSNumber *vdop;                     //vertical dilution of precision
@property (strong, readonly) const NSNumber *vbat;                      //battery level
@property (strong, readonly) const NSNumber *pInt;                      //internal pressure
@property (strong, readonly) const NSNumber *pExt;                      // external pressure

// color of pin used to display this observation, depends on the instituion for each float
@property (strong, readonly) const UIColor *color;

@property (assign) double legLength;
    
@property (assign) double legTime;

@property (assign) double legSpeed;

@property (assign) double netDisplacement;

@property (assign) double avgSpeed;

@property (assign) double totalTime;

@property (assign) double totalDistance;

@property (assign) double gebcoDepth;


// Returns a new FloatData object or NULL if orderedData is invalid
- (id)initWithRaw:(NSArray<NSString *> *)orderedData;

// Returns YES if the rawData is in a valid format
+ (BOOL)isValidRaw:(NSArray<NSString *> *)rawData;

- (void) updateLegDataUsingPreviousFloat:(FloatData *)prevFloat andFirstFloat:(FloatData *)firstFloat;

- (void) updateWithGebcoDepth;

+ (void) runTests;
@end
