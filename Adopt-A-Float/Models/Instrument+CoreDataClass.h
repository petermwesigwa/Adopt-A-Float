//
//  Instrument+CoreDataClass.h
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 2/6/21.
//  Copyright © 2021 Frederik Simons. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DataPoint+CoreDataClass.h"

@class DataPoint;

NS_ASSUME_NONNULL_BEGIN

@interface Instrument : NSManagedObject

- (void) provideName:(NSString *)instrName andData:(NSArray<NSArray<NSString*>*>*)rawData;

- (void) save;
@end

NS_ASSUME_NONNULL_END

#import "Instrument+CoreDataProperties.h"
