//
//  Instrument+CoreDataProperties.m
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 2/6/21.
//  Copyright © 2021 Frederik Simons. All rights reserved.
//
//

#import "Instrument+CoreDataProperties.h"

@implementation Instrument (CoreDataProperties)

+ (NSFetchRequest<Instrument *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Instrument"];
}

@dynamic name;
@dynamic rawData;
@dynamic dataPoints;

@end
