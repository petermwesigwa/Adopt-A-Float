//
//  Instrument+CoreDataClass.m
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 2/6/21.
//  Copyright © 2021 Frederik Simons. All rights reserved.
//
//

#import "Instrument+CoreDataClass.h"

@implementation Instrument

- (void) provideName:(NSString *)instrName andData:(NSArray<NSArray<NSString*>*>*)rawData {
    self.name = instrName;
    [self addDataFromRaw:rawData];
}

- (void) save {
    NSError *error = nil;
    if ([[self managedObjectContext] save:&error] == NO) {
        NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
    }
}

- (void) addDataFromRaw:(NSArray<NSArray<NSString*>*>*)raw {
    NSMutableArray<DataPoint*>*dataPoints = [NSMutableArray new];
    for (NSArray<NSString*>*dataRow in raw) {
        DataPoint *dp = [NSEntityDescription insertNewObjectForEntityForName:@"DataPoint" inManagedObjectContext:[self managedObjectContext]];
        
        [dp addDataFromRaw:dataRow];
        dp.instrument = self;
        [dataPoints addObject:dp];
    }
    
    for (int i = (int)dataPoints.count - 2; i >= 0; i--) {
        [dataPoints[i] addLegDataUsingPreviousPoint:dataPoints[i+1] andFirstPoint:[dataPoints lastObject]];
    }
}
@end
