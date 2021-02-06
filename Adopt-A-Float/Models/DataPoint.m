//
//  DataPoint.m
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 1/31/21.
//  Copyright © 2021 Frederik Simons. All rights reserved.
//

#import "DataPoint.h"

@implementation DataPoint

- (void) save {
    NSError *error = nil;
    if ([[self managedObjectContext] save:&error]) {
         NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
    }
    
}
@end
