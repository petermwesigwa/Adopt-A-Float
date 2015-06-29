//
//  Instrument.h
//  Adopt-A-Float
//
//  Created by Ben Leizman on 6/28/15.
//  Copyright (c) 2015 Son-O-Mermaid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Instrument : NSObject

@property NSString *name;
@property NSMutableArray *lat;
@property NSMutableArray *lon;

- (id)initWithName:(NSString*) name andLat:(NSArray*) lat andLon:(NSArray*) lon;

@end
