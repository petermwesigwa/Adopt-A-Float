//
//  DataPoint+CoreDataProperties.m
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 2/6/21.
//  Copyright © 2021 Frederik Simons. All rights reserved.
//
//

#import "DataPoint+CoreDataProperties.h"

@implementation DataPoint (CoreDataProperties)

+ (NSFetchRequest<DataPoint *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"DataPoint"];
}

@dynamic avgSpeed;
@dynamic deviceName;
@dynamic extPressure;
@dynamic gpsDate;
@dynamic gpsLat;
@dynamic gpsLon;
@dynamic hDop;
@dynamic intPressure;
@dynamic legLength;
@dynamic legSpeed;
@dynamic legTime;
@dynamic netDisplacement;
@dynamic totalDistance;
@dynamic totalTime;
@dynamic vBat;
@dynamic vDop;
@dynamic instrument;

@end
