//
//  DataPoint+CoreDataClass.h
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 2/6/21.
//  Copyright © 2021 Frederik Simons. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Instrument;

NS_ASSUME_NONNULL_BEGIN

@interface DataPoint : NSManagedObject

- (void) addDataFromRaw:(NSArray<NSString*>*)rawData;

- (void) matchWithInstrument:(Instrument *)instrument;

+ (BOOL) isValidRaw:(NSArray<NSString*>*)rawData;

- (void) save;

- (void) addLegDataUsingPreviousPoint:(DataPoint*)prevPoint andFirstPoint:(DataPoint*)firstPoint;
@end

NS_ASSUME_NONNULL_END

#import "DataPoint+CoreDataProperties.h"
