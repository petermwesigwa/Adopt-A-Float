//
//  Instrument+CoreDataClass.h
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 2/6/21.
//  Copyright © 2021 Frederik Simons. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DataPoint+CoreDataClass.h"

@class DataPoint;

NS_ASSUME_NONNULL_BEGIN

@interface Instrument : NSManagedObject

//+ (Instrument*) instrumentWithName:(NSString*) name data:(NSArray<NSArray<NSString*>*>*)data fromContext:(NSManagedObjectContext*)context;

- (void) provideData:(NSArray<NSArray<NSString*>*>*)raw;
- (void) save;

- (UIColor *) getColor;

- (BOOL) isEqualToInstrument:(Instrument *) that;

@end

NS_ASSUME_NONNULL_END

#import "Instrument+CoreDataProperties.h"
