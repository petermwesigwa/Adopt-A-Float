//
//  Instrument.h
//  Adopt-A-Float
//
//  Created by Ben Leizman on 6/28/15.
//  Copyright © 2018 Frederik Simons. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Instrument : NSObject

@property NSString *name;
@property NSMutableArray *floatData;

- (id)initWithName:(NSString*) name andfloatData:(NSMutableArray *)floatData;

@end
