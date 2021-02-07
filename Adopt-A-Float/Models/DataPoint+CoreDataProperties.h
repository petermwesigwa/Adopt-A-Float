//
//  DataPoint+CoreDataProperties.h
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 2/6/21.
//  Copyright © 2021 Frederik Simons. All rights reserved.
//
//

#import "DataPoint+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DataPoint (CoreDataProperties)

+ (NSFetchRequest<DataPoint *> *)fetchRequest;

@property (nonatomic) double avgSpeed;
@property (nullable, nonatomic, copy) NSString *deviceName;
@property (nonatomic) double extPressure;
@property (nullable, nonatomic, copy) NSDate *gpsDate;
@property (nonatomic) double gpsLat;
@property (nonatomic) double gpsLon;
@property (nonatomic) double hDop;
@property (nonatomic) double intPressure;
@property (nonatomic) double legLength;
@property (nonatomic) double legSpeed;
@property (nonatomic) double legTime;
@property (nullable, nonatomic, copy) NSDecimalNumber *netDisplacement;
@property (nonatomic) double totalDistance;
@property (nonatomic) double totalTime;
@property (nonatomic) double vBat;
@property (nonatomic) double vDop;
@property (nullable, nonatomic, retain) Instrument *instrument;

@end

NS_ASSUME_NONNULL_END
