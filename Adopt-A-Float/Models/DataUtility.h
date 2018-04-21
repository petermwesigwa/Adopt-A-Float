//
//  DataUtility.h
//  Adopt-A-Float
//
//  Created by Ben Leizman on 8/11/15.
//  Copyright © 2018 Frederik Simons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FloatData.h"
#import "Instrument.h"

@interface DataUtility : NSObject

// Tools for retrieveing instruments from online
+ (NSMutableDictionary<NSString *, Instrument *> *)createInstruments;
+ (NSDictionary *)getSourceURLs;
+ (NSMutableArray<FloatData *> *)getDataFromURL:(NSURL *)url;

@end
