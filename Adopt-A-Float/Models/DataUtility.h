//
//  DataUtility.h
//  Adopt-A-Float
//
//  Created by Ben Leizman on 8/11/15.
//  Modified by Peter Mwesigwa on 8/18/20
//  Copyright © 2018 Frederik Simons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FloatData.h"
#import "Instrument.h"

/*
Description:
 This file is useful for reading in data and setting up the 
 */

@interface DataUtility : NSObject


// This is the most important method provided by this class. This method creates all the instruments, initializing them with all the necessary observations using data fetched from the remote server. Returns a dictionary where each instrument can be retrieved by name.
+ (NSMutableDictionary<NSString *, Instrument *> *)createInstruments;

@end
