//
//  getData.h
//  Adopt-A-Float
//
//  Created by Ben Leizman on 8/11/15.
//  Copyright © 2018 Frederik Simons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FloatDataRow.h"
#import "Instrument.h"

@interface getData : NSObject

+ (NSMutableDictionary*) getData:(NSMutableDictionary*) instruments;

@end
