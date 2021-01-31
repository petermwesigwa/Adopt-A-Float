//
//  AppState.m
//  Adopt-A-Float
//
//  Created by Peter Mwesigwa on 8/30/20.
//  Copyright © 2020 Frederik Simons. All rights reserved.
//

#import "AppState.h"

@implementation AppState
 
-(id)initWithInstruments:(NSMutableDictionary<NSString *, Instrument*> *)instruments {
    self = [super init];
    if (self) {
        _instrNames = [[instruments allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        _selectedInstr = @"All";
        _selectedInstrIndex = -1;
        _mapViewTypes = [NSArray arrayWithObjects:
            [NSNumber numberWithInt:kGMSTypeHybrid],
            [NSNumber numberWithInt:kGMSTypeSatellite],
            [NSNumber numberWithInt:kGMSTypeNormal],
            [NSNumber numberWithInt:kGMSTypeTerrain],nil];
        _selectedMapViewIndex = 0;
    }
    return self;
}
@end
