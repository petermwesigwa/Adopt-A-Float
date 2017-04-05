//
//  FloatDataRow.h
//  Adopt-A-Float
//
//  Created by Ben Leizman on 10/10/15.
//  Copyright © 2015 Son-O-Mermaid. All rights reserved.
//

#import <Foundation/Foundation.h>

const NSCalendar *cal; //set to gregorian calendar

@interface FloatDataRow : NSObject

@property const NSDate* gpsDate; //
@property const NSDateComponents *gpsComponents;
@property const NSNumber* gpsLat; //latitude
@property const NSNumber* gpsLon; //longitude
@property const NSNumber* alt; //altitude (m)
@property const NSNumber* vsp; //vertical speed (m/s)
@property const NSNumber* vdop; //vertical dilution of precision
@property const NSNumber* gsp; //ground speed (m/s)
@property const NSNumber* hdop; //horizontal dop
@property const NSNumber* crs; //course
@property const NSNumber* sat; //Number of satelites used
@property const NSNumber* iByte; //Indicator byte
@property const NSDate *dopDate; // date from doppler
@property const NSDateComponents *dopComponents;
@property const NSNumber* dopLat;
@property const NSNumber* dopLon;
@property const NSNumber* CEPrad; //Estimate of unit location accuracy (circle radius) in km

-(id) initWithMutArr:(NSMutableArray*) raw;

@end
