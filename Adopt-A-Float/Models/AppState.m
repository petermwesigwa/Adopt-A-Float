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
        _instrNames = [[NSMutableArray alloc] initWithObjects:@"All", nil];
        [_instrNames addObjectsFromArray:[[instruments allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]];
        _markerNumbers = @[@1, @5, @10, @20, @INT_MAX];;
        _selectedInstr = @"All";
        _selectedInstrIndex = 0;
        _selectedMarkerNumIndex = 0;
        _mapViewTypes = [NSArray arrayWithObjects:
            [NSNumber numberWithInt:kGMSTypeHybrid],
            [NSNumber numberWithInt:kGMSTypeSatellite],
            [NSNumber numberWithInt:kGMSTypeNormal],
            [NSNumber numberWithInt:kGMSTypeTerrain],nil];
        _selectedMapViewIndex = 0;
        _orgFilters = [[NSMutableDictionary alloc] init];
    }
    return self;
}
@end
