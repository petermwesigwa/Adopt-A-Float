//
//  Instrument+CoreDataClass.m
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 2/6/21.
//  Copyright © 2021 Frederik Simons. All rights reserved.
//
//

#import "Instrument+CoreDataClass.h"

extern NSMutableDictionary<NSString *, UIColor *> *organizations;

@implementation Instrument
//+ (Instrument*) instrumentWithName:(NSString*) name data:(NSArray<NSArray<NSString*>*>*)data fromContext:(NSManagedObjectContext*)context {
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Instrument"];
//    request.predicate = [NSPredicate predicateWithFormat:"name LIKE %@", name];
//    //NSArray *results = [
//}


- (void) save {
    NSError *error = nil;
    if ([[self managedObjectContext] save:&error] == NO) {
        NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
    }
}

- (void) provideData:(NSArray<NSArray<NSString *> *> *)raw {
    self.institution = [Instrument assignInstitutionFor:self.name];
    for (NSArray<NSString*>*dataRow in raw) {
        DataPoint *dp = [NSEntityDescription insertNewObjectForEntityForName:@"DataPoint" inManagedObjectContext:[self managedObjectContext]];
        
        [dp addDataFromRaw:dataRow];
        if ([self.dataPoints containsObject:dp]) {
            continue;
        }
        [dp addLegDataUsingPreviousPoint:[self.dataPoints lastObject] andFirstPoint:[self.dataPoints firstObject]];
        
        [self addDataPointsObject:dp];
    }
}

- (BOOL) isEqualToInstrument:(Instrument *)that {
    return [self.name isEqualToString:that.name];
}
- (UIColor *)getColor {
    return organizations[self.institution];
}

/* Assign an instrument its color based off of the organization it belongs to. We can deduce the organization from the instrument's name*/
+ (NSString *)assignInstitutionFor:(NSString *)instrName {
    int float_id = [[instrName substringFromIndex:1] intValue];
    if (float_id == 6) { // GeoAzur
       return @"GeoAzur";
    }
    else if (float_id == 3 || float_id == 7) { // Dead
        //return [UIColor grayColor];
        return @"Inactive";
    }
    else if (float_id > 26 && float_id < 49) { // SUSTech
        //return [UIColor yellowColor];
       return @"SUSTech";
    }
    else if ([instrName hasPrefix:@"P"]) { // Princeton
        //return [UIColor orangeColor];
        return @"Princeton";
    }
    else {
        return @"JAMSTEC";
    }
    //return [UIColor redColor]; // JAMSTEC
}
@end
