//
//  DataPoint.h
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 1/31/21.
//  Copyright © 2021 Frederik Simons. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataPoint : NSManagedObject

@property (strong, nonatomic) const NSString *deviceName;  // name of the mermaid
@property (strong, nonatomic) const NSDate *gpsDate;       // date of reading
@property (strong, nonatomic) const NSNumber *gpsLat;      //latitude
@property (strong, nonatomic) const NSNumber *gpsLon;      //longitude
@property (strong, nonatomic) const NSNumber *hdop;     //horizontal dilution of precision
@property (strong, nonatomic) const NSNumber *vdop;        //vertical dilution of precision
@property (strong, nonatomic) const NSNumber *vbat;        //battery level
@property (strong, nonatomic) const NSNumber *pInt;        //internal pressure
@property (strong, nonatomic) const NSNumber *pExt;        // external pressure

// color of pin used to display this observation, depends on the instituion for each float
@property (strong, nonatomic) const UIColor *color;

@property (assign) double legLength;
    
@property (assign) double legTime;

@property (assign) double legSpeed;

@property (assign) double netDisplacement;

@property (assign) double avgSpeed;

@property (assign) double totalTime;

@property (assign) double totalDistance;

@property (assign) double gebcoDepth;

- (void) save;

@end

NS_ASSUME_NONNULL_END
