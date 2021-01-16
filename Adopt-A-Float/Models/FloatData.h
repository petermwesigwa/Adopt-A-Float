//
//  FloatData.h
//  Adopt-A-Float
//
//  Created by Ben Leizman on 10/10/15.
//  Modified by Peter Mwesigwa on 8/18/20
//  Copyright © 2018 Frederik Simons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FloatData : NSObject

@property (strong, readonly) const NSString *deviceName;                // number of MERMAID
@property (strong, readonly) const NSDate *gpsDate;                     // date of reading
@property (strong, readonly) const NSNumber *gpsLat;                    // WGS84 decimal latitude
@property (strong, readonly) const NSNumber *gpsLon;                    // WGS84 decimal longitude
@property (strong, readonly) const NSNumber *hdop;                      // horizontal dilution of precision
@property (strong, readonly) const NSNumber *vdop;                      // vertical dilution of precision
@property (strong, readonly) const NSNumber *vbat;                      // battery level in mV
@property (strong, readonly) const NSNumber *pInt;                      // internal pressure in Pa
@property (strong, readonly) const NSNumber *pExt;                      // external pressure in mbar

// color of pin used to display this observation, depends on the instituion for each float
@property (strong, readonly) const UIColor *color;

@property (assign) double legLength;                         // distance moved since last report
    
@property (assign) double legTime;                           // time since last report

@property (assign) double legSpeed;                          // average speed since last report

@property (assign) double netDisplacement;                  // displacement from position of first report

@property (assign) double avgSpeed;                         // average speed since first report

@property (assign) double totalTime;                        // total time since first report

@property (assign) double totalDistance;                    // distance covered since first report

@property (assign) double gebcoDepth;                       // GEBCO wms ocean depth at location of current report


// Returns a new FloatData object or NULL if orderedData is invalid
- (id)initWithRaw:(NSArray<NSString *> *)orderedData;

// Returns YES if the rawData is in a valid format
+ (BOOL)isValidRaw:(NSArray<NSString *> *)rawData;

/*  updateds leg variables for this FloatData object using most recent report and first report for the
    associated instrument
 */
- (void) updateLegDataUsingPreviousFloat:(FloatData *)prevFloat andFirstFloat:(FloatData *)firstFloat;

/* Testing module
 */
+ (void) runTests;
@end
