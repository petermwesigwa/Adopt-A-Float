//
//  Instrument+CoreDataProperties.h
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 2/6/21.
//  Copyright © 2021 Frederik Simons. All rights reserved.
//
//

#import "Instrument+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Instrument (CoreDataProperties)

+ (NSFetchRequest<Instrument *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *rawData;
@property (nullable, nonatomic, copy) NSString *institution;
@property (nullable, nonatomic, retain) NSOrderedSet<DataPoint *> *dataPoints;

@end

@interface Instrument (CoreDataGeneratedAccessors)

- (void)insertObject:(DataPoint *)value inDataPointsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromDataPointsAtIndex:(NSUInteger)idx;
- (void)insertDataPoints:(NSArray<DataPoint *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeDataPointsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInDataPointsAtIndex:(NSUInteger)idx withObject:(DataPoint *)value;
- (void)replaceDataPointsAtIndexes:(NSIndexSet *)indexes withDataPoints:(NSArray<DataPoint *> *)values;
- (void)addDataPointsObject:(DataPoint *)value;
- (void)removeDataPointsObject:(DataPoint *)value;
- (void)addDataPoints:(NSOrderedSet<DataPoint *> *)values;
- (void)removeDataPoints:(NSOrderedSet<DataPoint *> *)values;

@end

NS_ASSUME_NONNULL_END
